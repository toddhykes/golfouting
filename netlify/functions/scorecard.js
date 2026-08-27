// Netlify serverless function — proxies Anthropic API for scorecard lookup
// Set ANTHROPIC_API_KEY in Netlify: Site Settings → Environment Variables

exports.handler = async function(event) {
    const headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Content-Type': 'application/json'
    };

    if (event.httpMethod === 'OPTIONS') return { statusCode: 200, headers, body: '' };
    if (event.httpMethod !== 'POST') return { statusCode: 405, headers, body: JSON.stringify({ error: 'Method not allowed' }) };

    const apiKey = process.env.ANTHROPIC_API_KEY;
    if (!apiKey) return {
        statusCode: 500, headers,
        body: JSON.stringify({ error: 'ANTHROPIC_API_KEY not set in Netlify environment variables.' })
    };

    let body;
    try { body = JSON.parse(event.body); }
    catch(e) { return { statusCode: 400, headers, body: JSON.stringify({ error: 'Invalid JSON body' }) }; }

    const { prompt } = body;
    if (!prompt) return { statusCode: 400, headers, body: JSON.stringify({ error: 'Missing prompt' }) };

    try {
        const resp = await fetch('https://api.anthropic.com/v1/messages', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': apiKey,
                'anthropic-version': '2023-06-01'
            },
            body: JSON.stringify({
                model: 'claude-sonnet-5',
                max_tokens: 2000,
                system: 'You are a JSON API. You output ONLY valid JSON with no explanation, no markdown, no backticks, no prose. Your entire response must be parseable by JSON.parse().',
                messages: [{ role: 'user', content: prompt }]
            })
        });

        const data = await resp.json();

        if (!resp.ok) {
            return {
                statusCode: resp.status, headers,
                body: JSON.stringify({ error: data.error?.message || `Anthropic API error ${resp.status}` })
            };
        }

        return { statusCode: 200, headers, body: JSON.stringify(data) };
    } catch(err) {
        return { statusCode: 500, headers, body: JSON.stringify({ error: `Anthropic call failed: ${err.message}` }) };
    }
};
