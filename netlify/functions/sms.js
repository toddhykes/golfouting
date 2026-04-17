exports.handler = async function (event) {
    if (event.httpMethod !== 'POST') {
        return { statusCode: 405, body: 'Method Not Allowed' };
    }

    const { to, message } = JSON.parse(event.body || '{}');

    if (!to || !message) {
        return { statusCode: 400, body: JSON.stringify({ error: 'Missing to or message' }) };
    }

    const accountSid = process.env.TWILIO_ACCOUNT_SID;
    const authToken  = process.env.TWILIO_AUTH_TOKEN;
    const fromNumber = process.env.TWILIO_FROM_NUMBER;

    if (!accountSid || !authToken || !fromNumber) {
        return { statusCode: 500, body: JSON.stringify({ error: 'Twilio env vars not configured' }) };
    }

    // Twilio REST API — no SDK needed
    const url = `https://api.twilio.com/2010-04-01/Accounts/${accountSid}/Messages.json`;
    const credentials = Buffer.from(`${accountSid}:${authToken}`).toString('base64');

    const body = new URLSearchParams({
        To:   to.startsWith('+') ? to : `+1${to.replace(/\D/g, '')}`, // default to US +1
        From: fromNumber,
        Body: message
    });

    const response = await fetch(url, {
        method: 'POST',
        headers: {
            'Authorization': `Basic ${credentials}`,
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body.toString()
    });

    const result = await response.json();

    if (!response.ok) {
        console.error('Twilio error:', result);
        return {
            statusCode: response.status,
            body: JSON.stringify({ error: result.message || 'Twilio request failed' })
        };
    }

    return {
        statusCode: 200,
        body: JSON.stringify({ sid: result.sid, status: result.status })
    };
};
