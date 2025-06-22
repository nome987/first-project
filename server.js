const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const { spawn } = require('child_process');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// Security and performance middleware
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'", "https://fonts.googleapis.com"],
      fontSrc: ["'self'", "https://fonts.gstatic.com"],
      scriptSrc: ["'self'", "'unsafe-inline'", "'unsafe-eval'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'", "ws:", "wss:"]
    }
  }
}));

app.use(compression());
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'],
  credentials: true
}));

app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// API status endpoint
app.get('/api/status', (req, res) => {
  res.json({
    gradio_status: 'running',
    database_status: process.env.DATABASE_URL ? 'connected' : 'not_configured',
    ai_models: 'ready',
    features: {
      resume_generation: true,
      cover_letter_generation: true,
      resume_analysis: true,
      ats_scoring: true,
      job_matching: true,
      skill_gap_analysis: true,
      linkedin_generation: true,
      career_dashboard: true,
      ai_chatbot: true,
      database_storage: !!process.env.DATABASE_URL
    }
  });
});

// Serve static files
app.use('/static', express.static(path.join(__dirname, 'static')));

// Start Python Gradio application
let gradioProcess = null;

function startGradioApp() {
  console.log('Starting AI Resume Builder application...');
  
  // Determine which interface to use based on environment
  const interfaceFile = process.env.DATABASE_URL 
    ? 'AIResumeBuilder/database_interface.py'
    : process.env.PREMIUM_MODE === 'true'
    ? 'AIResumeBuilder/premium_interface.py'
    : 'AIResumeBuilder/production_interface.py';
  
  gradioProcess = spawn('python', [interfaceFile], {
    cwd: __dirname,
    env: {
      ...process.env,
      PYTHONPATH: path.join(__dirname, 'AIResumeBuilder'),
      GRADIO_SERVER_NAME: '0.0.0.0',
      GRADIO_SERVER_PORT: '7860'
    }
  });

  gradioProcess.stdout.on('data', (data) => {
    console.log(`Gradio: ${data}`);
  });

  gradioProcess.stderr.on('data', (data) => {
    console.error(`Gradio Error: ${data}`);
  });

  gradioProcess.on('close', (code) => {
    console.log(`Gradio process exited with code ${code}`);
    if (code !== 0) {
      console.log('Restarting Gradio application...');
      setTimeout(startGradioApp, 5000);
    }
  });
}

// Proxy requests to Gradio
app.use('/gradio', (req, res) => {
  const gradioUrl = `http://localhost:7860${req.url}`;
  
  const options = {
    method: req.method,
    headers: {
      ...req.headers,
      host: 'localhost:7860'
    }
  };

  if (req.method === 'POST' || req.method === 'PUT') {
    options.body = JSON.stringify(req.body);
    options.headers['content-type'] = 'application/json';
  }

  fetch(gradioUrl, options)
    .then(response => {
      res.status(response.status);
      response.headers.forEach((value, key) => {
        res.setHeader(key, value);
      });
      return response.body;
    })
    .then(body => {
      if (body) {
        body.pipe(res);
      } else {
        res.end();
      }
    })
    .catch(error => {
      console.error('Proxy error:', error);
      res.status(500).json({ error: 'Internal server error' });
    });
});

// Main route - redirect to Gradio interface
app.get('/', (req, res) => {
  res.redirect('/gradio');
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({ 
    error: 'Internal server error',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully...');
  if (gradioProcess) {
    gradioProcess.kill('SIGTERM');
  }
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully...');
  if (gradioProcess) {
    gradioProcess.kill('SIGINT');
  }
  process.exit(0);
});

// Start the server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 AI Resume Builder server running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`🔧 API status: http://localhost:${PORT}/api/status`);
  console.log(`🎯 Application: http://localhost:${PORT}`);
  
  // Start Gradio application
  startGradioApp();
});