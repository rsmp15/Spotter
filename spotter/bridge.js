const http = require('http');
const fs = require('fs');
const path = require('path');

const CONFIG_PATH = path.join(__dirname, 'remote_config.json');

const defaultConfig = {
  show_promo_banner: true,
  promo_banner_text: "Get 20% off your next ride!",
  maintenance_mode: false,
  show_offers: true,
  offer_title: "Offers & Deals",
  offer_subtitle: "Get best deals and discounts",
  home_offer_cards: [
    {
      title: "Flat 20% OFF",
      subtitle: "Use code: SPOTT20",
      icon: "local_offer_rounded",
      startColor: "#E21E4A",
      endColor: "#FFDADA",
      route: "/parcel-booking"
    },
    {
      title: "First Ride Free",
      subtitle: "New users only",
      icon: "card_giftcard_rounded",
      startColor: "#0070EB",
      endColor: "#D8E2FF",
      route: "/parcel-booking"
    },
    {
      title: "Refer & Earn",
      subtitle: "₹100 per referral",
      icon: "share_rounded",
      startColor: "#00875A",
      endColor: "#D2F4E4",
      route: "/parcel-booking"
    }
  ],
  parcel_banner: {
    title: "Send Parcels from ₹99",
    subtitle: "Fast peer-to-peer dispatch via verified travelers.",
    startColor: "#7C3AED",
    endColor: "#4C1D95",
    buttonText: "Send Parcel Now",
    tagText: "PARCEL DELIVERY"
  }
};

// Ensure default config exists
if (!fs.existsSync(CONFIG_PATH)) {
  fs.writeFileSync(CONFIG_PATH, JSON.stringify(defaultConfig, null, 2), 'utf8');
}

const server = http.createServer((req, res) => {
  // CORS Headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  if (req.url === '/api/config' && req.method === 'GET') {
    fs.readFile(CONFIG_PATH, 'utf8', (err, data) => {
      if (err) {
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Failed to read config' }));
        return;
      }
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(data);
    });
  } else if (req.url === '/api/config' && req.method === 'POST') {
    let body = '';
    req.on('data', chunk => {
      body += chunk.toString();
    });
    req.on('end', () => {
      try {
        const parsed = JSON.parse(body);
        fs.writeFile(CONFIG_PATH, JSON.stringify(parsed, null, 2), 'utf8', (err) => {
          if (err) {
            res.writeHead(500, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: 'Failed to write config' }));
            return;
          }
          res.writeHead(200, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ status: 'ok', config: parsed }));
        });
      } catch (e) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Invalid JSON body' }));
      }
    });
  } else {
    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Not Found' }));
  }
});

const PORT = 5050;
server.listen(PORT, () => {
  console.log(`🚀 Bridge server running at http://localhost:${PORT}`);
});
