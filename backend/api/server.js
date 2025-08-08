const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const AWS = require('aws-sdk');
const Redis = require('redis');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Initialize AWS services
const sqs = new AWS.SQS();
const s3 = new AWS.S3();

// Initialize Redis client
const redis = Redis.createClient({
    url: process.env.REDIS_URL || 'redis://localhost:6379'
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// API Routes
app.get('/api/contacts', async (req, res) => {
    try {
        // Get contacts from cache or database
        const contacts = await getContacts();
        res.json(contacts);
    } catch (error) {
        console.error('Error fetching contacts:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/api/contacts', async (req, res) => {
    try {
        const contactData = req.body;
        
        // Send to SQS for processing
        await sqs.sendMessage({
            QueueUrl: process.env.CONTACTS_QUEUE_URL,
            MessageBody: JSON.stringify(contactData)
        }).promise();
        
        res.json({ message: 'Contact queued for processing', id: contactData.id });
    } catch (error) {
        console.error('Error queuing contact:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.get('/api/projects', async (req, res) => {
    try {
        const projects = await getProjects();
        res.json(projects);
    } catch (error) {
        console.error('Error fetching projects:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.post('/api/projects', async (req, res) => {
    try {
        const projectData = req.body;
        
        await sqs.sendMessage({
            QueueUrl: process.env.PROJECTS_QUEUE_URL,
            MessageBody: JSON.stringify(projectData)
        }).promise();
        
        res.json({ message: 'Project queued for processing', id: projectData.id });
    } catch (error) {
        console.error('Error queuing project:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Helper functions
async function getContacts() {
    // Simulate database query
    return [
        { id: 1, name: 'John Doe', email: 'john@example.com' },
        { id: 2, name: 'Jane Smith', email: 'jane@example.com' }
    ];
}

async function getProjects() {
    // Simulate database query
    return [
        { id: 1, name: 'Project Alpha', status: 'active' },
        { id: 2, name: 'Project Beta', status: 'completed' }
    ];
}

// Start server
app.listen(PORT, () => {
    console.log(`MigrationAI Backend API running on port ${PORT}`);
    console.log(`Health check: http://localhost:${PORT}/health`);
});
