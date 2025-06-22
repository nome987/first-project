/*
  # AI Resume Builder Database Schema

  1. New Tables
    - `users` - User account management with profile data
    - `resumes` - Generated resumes with analysis scores
    - `cover_letters` - Generated cover letters for applications
    - `job_applications` - Job application tracking
    - `skill_assessments` - Skill gap analysis results
    - `chat_history` - AI advisor conversation history
    - `analytics` - User activity tracking and analytics

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to access their own data
    - Secure data isolation per user

  3. Performance
    - Optimized indexes for common queries
    - JSONB fields for flexible data storage
    - Efficient foreign key relationships
*/

-- Enable UUID extension for generating unique identifiers
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create users table for account management
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    email VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_active TIMESTAMPTZ DEFAULT NOW(),
    profile_data JSONB DEFAULT '{}'::jsonb
);

-- Create resumes table for storing generated resumes
CREATE TABLE IF NOT EXISTS resumes (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    resume_name VARCHAR(255) NOT NULL,
    content TEXT,
    job_role VARCHAR(255),
    skills TEXT[],
    experience TEXT,
    education TEXT,
    pdf_path VARCHAR(500),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    analysis_score INTEGER DEFAULT 0,
    ats_scores JSONB DEFAULT '{}'::jsonb,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create cover_letters table for storing generated cover letters
CREATE TABLE IF NOT EXISTS cover_letters (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    job_role VARCHAR(255) NOT NULL,
    content TEXT,
    pdf_path VARCHAR(500),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create job_applications table for tracking applications
CREATE TABLE IF NOT EXISTS job_applications (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    job_title VARCHAR(255) NOT NULL,
    job_description TEXT,
    resume_id INTEGER,
    cover_letter_id INTEGER,
    application_status VARCHAR(50) DEFAULT 'draft',
    ats_score FLOAT DEFAULT 0,
    applied_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (resume_id) REFERENCES resumes(id) ON DELETE SET NULL,
    FOREIGN KEY (cover_letter_id) REFERENCES cover_letters(id) ON DELETE SET NULL
);

-- Create skill_assessments table for skill gap analysis
CREATE TABLE IF NOT EXISTS skill_assessments (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    target_role VARCHAR(255),
    current_skills TEXT[],
    missing_skills TEXT[],
    skill_gap_score FLOAT,
    learning_recommendations JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create chat_history table for AI advisor conversations
CREATE TABLE IF NOT EXISTS chat_history (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    user_message TEXT NOT NULL,
    ai_response TEXT NOT NULL,
    session_id VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    feedback_rating INTEGER DEFAULT NULL,
    message_category VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create analytics table for user activity tracking
CREATE TABLE IF NOT EXISTS analytics (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    action_type VARCHAR(100) NOT NULL,
    action_data JSONB DEFAULT '{}'::jsonb,
    session_id VARCHAR(255),
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create performance indexes
CREATE INDEX IF NOT EXISTS idx_users_user_id ON users(user_id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_resumes_user_id ON resumes(user_id);
CREATE INDEX IF NOT EXISTS idx_resumes_created_at ON resumes(created_at);
CREATE INDEX IF NOT EXISTS idx_cover_letters_user_id ON cover_letters(user_id);
CREATE INDEX IF NOT EXISTS idx_cover_letters_created_at ON cover_letters(created_at);
CREATE INDEX IF NOT EXISTS idx_job_applications_user_id ON job_applications(user_id);
CREATE INDEX IF NOT EXISTS idx_job_applications_status ON job_applications(application_status);
CREATE INDEX IF NOT EXISTS idx_skill_assessments_user_id ON skill_assessments(user_id);
CREATE INDEX IF NOT EXISTS idx_chat_history_user_id ON chat_history(user_id);
CREATE INDEX IF NOT EXISTS idx_chat_history_session ON chat_history(session_id);
CREATE INDEX IF NOT EXISTS idx_analytics_user_id ON analytics(user_id);
CREATE INDEX IF NOT EXISTS idx_analytics_action_type ON analytics(action_type);
CREATE INDEX IF NOT EXISTS idx_analytics_created_at ON analytics(created_at);

-- Enable Row Level Security (RLS) on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE resumes ENABLE ROW LEVEL SECURITY;
ALTER TABLE cover_letters ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE skill_assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for users table
CREATE POLICY "Users can read own data" ON users
    FOR SELECT USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own data" ON users
    FOR INSERT WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own data" ON users
    FOR UPDATE USING (auth.uid()::text = user_id);

-- Create RLS policies for resumes table
CREATE POLICY "Users can read own resumes" ON resumes
    FOR SELECT USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own resumes" ON resumes
    FOR INSERT WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own resumes" ON resumes
    FOR UPDATE USING (auth.uid()::text = user_id);

CREATE POLICY "Users can delete own resumes" ON resumes
    FOR DELETE USING (auth.uid()::text = user_id);

-- Create RLS policies for cover_letters table
CREATE POLICY "Users can read own cover letters" ON cover_letters
    FOR SELECT USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own cover letters" ON cover_letters
    FOR INSERT WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own cover letters" ON cover_letters
    FOR UPDATE USING (auth.uid()::text = user_id);

CREATE POLICY "Users can delete own cover letters" ON cover_letters
    FOR DELETE USING (auth.uid()::text = user_id);

-- Create RLS policies for job_applications table
CREATE POLICY "Users can read own job applications" ON job_applications
    FOR SELECT USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own job applications" ON job_applications
    FOR INSERT WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own job applications" ON job_applications
    FOR UPDATE USING (auth.uid()::text = user_id);

CREATE POLICY "Users can delete own job applications" ON job_applications
    FOR DELETE USING (auth.uid()::text = user_id);

-- Create RLS policies for skill_assessments table
CREATE POLICY "Users can read own skill assessments" ON skill_assessments
    FOR SELECT USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own skill assessments" ON skill_assessments
    FOR INSERT WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own skill assessments" ON skill_assessments
    FOR UPDATE USING (auth.uid()::text = user_id);

CREATE POLICY "Users can delete own skill assessments" ON skill_assessments
    FOR DELETE USING (auth.uid()::text = user_id);

-- Create RLS policies for chat_history table
CREATE POLICY "Users can read own chat history" ON chat_history
    FOR SELECT USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own chat history" ON chat_history
    FOR INSERT WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own chat history" ON chat_history
    FOR UPDATE USING (auth.uid()::text = user_id);

-- Create RLS policies for analytics table
CREATE POLICY "Users can read own analytics" ON analytics
    FOR SELECT USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own analytics" ON analytics
    FOR INSERT WITH CHECK (auth.uid()::text = user_id);

-- Create functions for automatic timestamp updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for automatic timestamp updates
CREATE TRIGGER update_resumes_updated_at 
    BEFORE UPDATE ON resumes 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_cover_letters_updated_at 
    BEFORE UPDATE ON cover_letters 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data for testing (optional)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = 'demo_user_001') THEN
        INSERT INTO users (user_id, name, email, profile_data) VALUES 
        ('demo_user_001', 'Demo User', 'demo@example.com', '{"demo": true, "onboarding_completed": false}');
    END IF;
END $$;