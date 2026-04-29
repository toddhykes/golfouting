// Twilio inbound webhook — handles STOP / HELP replies for compliance.
// Configure in Twilio Console → Phone Numbers → Your Number →
//   Messaging → "A MESSAGE COMES IN": POST https://your-site/.netlify/functions/sms-inbound

exports.handler = async function (event) {
    if (event.httpMethod !== 'POST') {
        return { statusCode: 405, body: 'Method Not Allowed' };
    }

    // Twilio sends form-urlencoded
    const params = new URLSearchParams(event.body || '');
    const from = params.get('From') || '';
    const body = (params.get('Body') || '').trim().toUpperCase();

    console.log(`Inbound SMS from ${from}: "${body}"`);

    // Twilio auto-handles STOP/HELP at the carrier level once registered,
    // but we respond explicitly to be safe and TCR-compliant.
    let responseMessage = null;

    if (['STOP', 'STOPALL', 'UNSUBSCRIBE', 'CANCEL', 'END', 'QUIT'].includes(body)) {
        responseMessage = 'You have been unsubscribed from this golf event. No further messages will be sent. Reply START to resubscribe.';
    } else if (body === 'START' || body === 'UNSTOP') {
        responseMessage = 'You have been resubscribed. Reply STOP at any time to opt out.';
    } else if (body === 'HELP' || body === 'INFO') {
        responseMessage = 'Golf outing tracker. Reply STOP to unsubscribe. Contact your event organizer for assistance.';
    }

    // TwiML response
    const twiml = responseMessage
        ? `<?xml version="1.0" encoding="UTF-8"?><Response><Message>${responseMessage}</Message></Response>`
        : `<?xml version="1.0" encoding="UTF-8"?><Response></Response>`;

    return {
        statusCode: 200,
        headers: { 'Content-Type': 'text/xml' },
        body: twiml
    };
};
