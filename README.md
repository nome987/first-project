# AI Resume Builder - Production Ready

A comprehensive AI-powered career development platform featuring resume generation, cover letter creation, ATS optimization, job matching, and career consultation.

## 🚀 Features

### Core AI Tools
- **AI Resume Generator**: Create professional resumes using advanced AI models
- **AI Cover Letter Generator**: Generate personalized cover letters for specific companies
- **Resume Analyzer**: Get detailed feedback and improvement suggestions
- **ATS Score Calculator**: Optimize resumes for Applicant Tracking Systems
- **Job Matcher**: Find matching opportunities based on your skills
- **Skill Gap Analysis**: Identify skills needed for target roles
- **LinkedIn Summary Generator**: Create compelling professional profiles
- **Career Dashboard**: Comprehensive career insights and analytics
- **AI Career Advisor**: Real-time career consultation chatbot

### Advanced Features
- **Database Integration**: Store and track all career documents
- **User Analytics**: Track usage patterns and career progress
- **PDF Export**: Professional document formatting
- **Real-time AI**: Powered by Hugging Face models
- **Responsive Design**: Works on all devices
- **Security**: Enterprise-grade security measures

## 🛠 Technology Stack

### Backend
- **Python**: Core application logic
- **Gradio**: Web interface framework
- **Node.js**: API server and proxy
- **PostgreSQL**: Database for user data
- **Transformers**: AI model integration

### AI & ML
- **Hugging Face**: AI model hosting
- **Sentence Transformers**: Text similarity
- **TF-IDF**: Keyword matching
- **Scikit-learn**: Machine learning utilities

### Infrastructure
- **Docker**: Containerization
- **Nginx**: Reverse proxy and load balancing
- **Docker Compose**: Multi-service orchestration

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- 4GB+ RAM recommended
- Internet connection for AI models

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd ai-resume-builder
```

2. **Run deployment script**
```bash
chmod +x deploy.sh
./deploy.sh
```

3. **Configure environment**
```bash
cp .env.example .env
# Edit .env with your settings
```

4. **Access the application**
- Main Application: http://localhost
- Health Check: http://localhost:5000/health
- API Status: http://localhost:5000/api/status

### Manual Installation

1. **Install dependencies**
```bash
npm install
pip install -r requirements.txt
```

2. **Set up database** (optional)
```bash
# Start PostgreSQL
docker run -d --name postgres \
  -e POSTGRES_DB=ai_resume_builder \
  -e POSTGRES_PASSWORD=password \
  -p 5432:5432 postgres:15-alpine
```

3. **Start the application**
```bash
npm start
```

## 📁 Project Structure

```
ai-resume-builder/
├── AIResumeBuilder/                 # Python application
│   ├── database_interface.py        # Database-enhanced interface
│   ├── premium_interface.py         # Premium UI with animations
│   ├── production_interface.py      # Production-ready interface
│   ├── database_manager.py          # Database operations
│   ├── production_career_toolkit.py # Core AI functionality
│   └── career_toolkit.py           # Basic toolkit functions
├── server.js                       # Node.js server
├── package.json                    # Node.js dependencies
├── requirements.txt                # Python dependencies
├── Dockerfile                      # Container configuration
├── docker-compose.yml             # Multi-service setup
├── nginx.conf                     # Reverse proxy config
├── deploy.sh                      # Deployment script
└── README.md                      # This file
```

## ⚙️ Configuration

### Environment Variables

```bash
# Server Configuration
PORT=5000
NODE_ENV=production
PREMIUM_MODE=true

# Database (Optional)
DATABASE_URL=postgresql://user:pass@localhost:5432/ai_resume_builder

# AI Models (Optional)
HF_TOKEN=your_hugging_face_token

# Security
SESSION_SECRET=your_secure_secret
```

### Application Modes

1. **Basic Mode**: Core functionality without database
2. **Premium Mode**: Enhanced UI with animations
3. **Database Mode**: Full features with user tracking

## 🔧 API Endpoints

### Health & Status
- `GET /health` - Application health check
- `GET /api/status` - Detailed system status

### Core Features
- Resume generation via Gradio interface
- Cover letter creation
- Document analysis and scoring
- Job matching and recommendations
- Career consultation chat

## 🐳 Docker Deployment

### Single Container
```bash
docker build -t ai-resume-builder .
docker run -p 5000:5000 -p 7860:7860 ai-resume-builder
```

### Full Stack with Database
```bash
docker-compose up -d
```

### Production Deployment
```bash
# With SSL and custom domain
docker-compose -f docker-compose.prod.yml up -d
```

## 📊 Monitoring

### Health Checks
- Application: `curl http://localhost:5000/health`
- Database: Check connection in status endpoint
- AI Models: Verify in application interface

### Logs
```bash
# View all logs
docker-compose logs -f

# Specific service
docker-compose logs -f ai-resume-builder
```

## 🔒 Security

### Features
- Helmet.js security headers
- CORS protection
- Rate limiting via Nginx
- Input validation and sanitization
- Secure file upload handling

### Best Practices
- Use environment variables for secrets
- Enable HTTPS in production
- Regular security updates
- Database connection encryption

## 🚀 Deployment Options

### Cloud Platforms
- **AWS**: ECS, EC2, or Elastic Beanstalk
- **Google Cloud**: Cloud Run or Compute Engine
- **Azure**: Container Instances or App Service
- **DigitalOcean**: App Platform or Droplets

### Platform-Specific Guides

#### Heroku
```bash
# Install Heroku CLI and login
heroku create ai-resume-builder
heroku addons:create heroku-postgresql:hobby-dev
git push heroku main
```

#### Railway
```bash
# Connect GitHub repository
# Add environment variables
# Deploy automatically
```

#### Render
```bash
# Connect repository
# Set build command: npm run build
# Set start command: npm start
```

## 🔧 Troubleshooting

### Common Issues

1. **Port conflicts**
   - Change ports in docker-compose.yml
   - Check for running services

2. **Memory issues**
   - Increase Docker memory allocation
   - Use lighter AI models

3. **Database connection**
   - Verify DATABASE_URL format
   - Check network connectivity

4. **AI model loading**
   - Ensure internet connection
   - Check Hugging Face token

### Debug Mode
```bash
# Enable debug logging
export DEBUG_MODE=true
npm start
```

## 📈 Performance Optimization

### Recommendations
- Use SSD storage for database
- Enable Redis caching
- Implement CDN for static assets
- Use load balancing for high traffic

### Scaling
- Horizontal scaling with multiple containers
- Database read replicas
- AI model caching
- Queue system for heavy operations

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes with tests
4. Submit pull request

## 📄 License

MIT License - see LICENSE file for details

## 🆘 Support

- **Documentation**: Check README and code comments
- **Issues**: Create GitHub issue with details
- **Community**: Join discussions in repository

## 🎯 Roadmap

### Upcoming Features
- Multi-language support
- Advanced analytics dashboard
- Integration with job boards
- Mobile application
- Enterprise features

### Version History
- v1.0.0: Initial production release
- v0.9.0: Database integration
- v0.8.0: Premium UI implementation
- v0.7.0: Core AI functionality

---

**Built with ❤️ for career development**