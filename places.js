// Netlify serverless function — proxies Google Places Text Search
// Keeps the API key server-side in an environment variable (GOOGLE_MAPS_API_KEY)
// Set it in Netlify: Site Settings → Environment Variables

exports.handler = async function(event) {
    const headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Content-Type': 'application/json'
    };

    // Handle preflight
    if (event.httpMethod === 'OPTIONS') {
        return { statusCode: 200, headers, body: '' };
    }

    const apiKey = process.env.GOOGLE_MAPS_API_KEY;
    if (!apiKey) {
        return {
            statusCode: 500,
            headers,
            body: JSON.stringify({ error: 'GOOGLE_MAPS_API_KEY not set in Netlify environment variables. Go to Site Settings → Environment Variables and add it.' })
        };
    }

    const query = event.queryStringParameters?.query;
    if (!query) {
        return { statusCode: 400, headers, body: JSON.stringify({ error: 'Missing query parameter' }) };
    }

    try {
        const url = `https://maps.googleapis.com/maps/api/place/textsearch/json?query=${encodeURIComponent(query)}&type=golf_course&key=${apiKey}`;
        const resp = await fetch(url);
        const data = await resp.json();
        return { statusCode: 200, headers, body: JSON.stringify(data) };
    } catch (err) {
        return {
            statusCode: 500,
            headers,
            body: JSON.stringify({ error: `Places API call failed: ${err.message}` })
        };
    }
};
