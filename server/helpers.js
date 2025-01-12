// helpers/parkingHelpers.js

class ParkingHelpers {
    constructor(parkingSlots) {
      this.parkingSlots = parkingSlots;
    }
  
    // Find the next available parking slot
    findAvailableSlot() {
      return this.parkingSlots.slots.find(slot => slot.available);
    }
  
    // Update the status of a specific slot
    updateSlotStatus(slotId, isAvailable) {
      const slot = this.parkingSlots.slots.find(s => s.id === slotId);
      if (slot) {
        slot.available = isAvailable;
        return true;
      }
      return false;
    }
  
    // Get all available slots
    getAvailableSlots() {
      return this.parkingSlots.slots.filter(slot => slot.available);
    }
  
    // Get slot by ID
    getSlotById(slotId) {
      return this.parkingSlots.slots.find(slot => slot.id === slotId);
    }
  
    // Calculate parking duration
    calculateParkingDuration(entryTime) {
      const currentTime = new Date();
      const duration = Math.floor((currentTime - new Date(entryTime)) / (1000 * 60)); // Duration in minutes
      return duration;
    }
  
    // Calculate parking fee
    calculateParkingFee(duration) {
      const baseRate = 10; // Base rate for first hour
      const additionalRate = 5; // Rate per additional hour
      const hours = Math.ceil(duration / 60);
      
      if (hours <= 1) return baseRate;
      return baseRate + (hours - 1) * additionalRate;
    }
  
    // Validate slot coordinates
    validateSlotCoordinates(coordinates) {
      return (
        coordinates &&
        typeof coordinates.x === 'number' &&
        typeof coordinates.y === 'number' &&
        coordinates.x >= 0 &&
        coordinates.y >= 0
      );
    }
  
    // Format slot data for client response
    formatSlotData(slot) {
      return {
        id: slot.id,
        available: slot.available,
        coordinates: slot.coordinates,
        lastUpdated: new Date().toISOString()
      };
    }
  
    // Check if parking is full
    isParkingFull() {
      return !this.parkingSlots.slots.some(slot => slot.available);
    }
  
    // Get parking occupancy statistics
    getParkingStatistics() {
      const totalSlots = this.parkingSlots.slots.length;
      const occupiedSlots = this.parkingSlots.slots.filter(slot => !slot.available).length;
      
      return {
        totalSlots,
        occupiedSlots,
        availableSlots: totalSlots - occupiedSlots,
        occupancyRate: ((occupiedSlots / totalSlots) * 100).toFixed(2)
      };
    }
  }
  
  module.exports = ParkingHelpers;