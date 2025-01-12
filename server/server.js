// server.js
const WebSocket = require('ws');
const express = require('express');
const ParkingHelpers = require('./helpers');
const cors = require("cors");
dotenv.config();  //configure dotnet file
const app = express();
const server = require('http').createServer(app);
const wss = new WebSocketServer({ server });

app.use(cors());
app.use(express.json());
// Initialize parking state
const parkingState = {
  slots: [
    { id: 1, available: true, coordinates: { x: 1, y: 1 } },
    { id: 2, available: true, coordinates: { x: 1, y: 2 } },
    { id: 3, available: true, coordinates: { x: 2, y: 1 } },
    { id: 4, available: true, coordinates: { x: 2, y: 2 } }
  ]
};

// Initialize helpers
const parkingHelpers = new ParkingHelpers(parkingState);

// Keep track of connected clients
const clients = new Map();

wss.on('connection', (ws) => {
  const clientId = Date.now();
  
  ws.on('message', (message) => {
    try {
      const data = JSON.parse(message);
      
      switch(data.type) {
        case 'CLIENT_REGISTER':
          clients.set(clientId, { ws, type: data.clientType });
          ws.send(JSON.stringify({
            type: 'REGISTRATION_SUCCESS',
            slots: parkingState,
            statistics: parkingHelpers.getParkingStatistics()
          }));
          break;
          
        case 'CAR_ARRIVED':
          if (parkingHelpers.isParkingFull()) {
            ws.send(JSON.stringify({ type: 'NO_SLOTS_AVAILABLE' }));
            return;
          }
          
          const availableSlot = parkingHelpers.findAvailableSlot();
          if (availableSlot) {
            parkingHelpers.updateSlotStatus(availableSlot.id, false);
            
            const slotData = parkingHelpers.formatSlotData(availableSlot);
            broadcastToMobileClients({
              type: 'SLOT_ASSIGNED',
              slot: slotData
            });
            
            ws.send(JSON.stringify({
              type: 'NAVIGATION_DATA',
              slot: slotData
            }));
          }
          break;
          
        case 'CAR_PARKED':
          if (parkingHelpers.updateSlotStatus(data.slotId, false)) {
            broadcastToAllClients({
              type: 'SLOT_UPDATE',
              slots: parkingState,
              statistics: parkingHelpers.getParkingStatistics()
            });
          }
          break;
          
        case 'CAR_LEFT':
          if (parkingHelpers.updateSlotStatus(data.slotId, true)) {
            const duration = parkingHelpers.calculateParkingDuration(data.entryTime);
            const fee = parkingHelpers.calculateParkingFee(duration);
            
            broadcastToAllClients({
              type: 'SLOT_UPDATE',
              slots: parkingState,
              statistics: parkingHelpers.getParkingStatistics()
            });
            
            ws.send(JSON.stringify({
              type: 'PARKING_SUMMARY',
              duration,
              fee
            }));
          }
          break;
      }
    } catch (error) {
      console.error('Error processing message:', error);
    }
  });
  
  ws.on('close', () => {
    clients.delete(clientId);
  });
});

// Broadcasting functions
function broadcastToMobileClients(message) {
  clients.forEach((client) => {
    if (client.type === 'mobile' && client.ws.readyState === WebSocket.OPEN) {
      client.ws.send(JSON.stringify(message));
    }
  });
}

function broadcastToAllClients(message) {
  clients.forEach((client) => {
    if (client.ws.readyState === WebSocket.OPEN) {
      client.ws.send(JSON.stringify(message));
    }
  });
}

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`WebSocket server is running on port ${PORT}`);
});