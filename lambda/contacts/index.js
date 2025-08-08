const AWS = require('aws-sdk');
const sqs = new AWS.SQS();

exports.handler = async (event) => {
    console.log('Contacts Lambda function triggered');
    
    try {
        // Process SQS messages
        for (const record of event.Records) {
            const message = JSON.parse(record.body);
            console.log('Processing contact:', message);
            
            // Business logic for contact processing
            await processContact(message);
        }
        
        return {
            statusCode: 200,
            body: JSON.stringify({ message: 'Contacts processed successfully' })
        };
    } catch (error) {
        console.error('Error processing contacts:', error);
        throw error;
    }
};

async function processContact(contactData) {
    // Simulate contact processing
    console.log('Processing contact:', contactData.name);
    
    // Add your business logic here:
    // - Validate contact data
    // - Store in database
    // - Send notifications
    // - Update CRM systems
    
    return { success: true, contactId: contactData.id };
}
