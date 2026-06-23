"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createTrip = createTrip;
exports.searchTrips = searchTrips;
exports.getTrip = getTrip;
exports.updateTripStatus = updateTripStatus;
exports.updateLocation = updateLocation;
const supabase_js_1 = require("../../config/supabase.js");
async function createTrip(req, res, next) {
    try {
        const { vehicleId, source, sourceLat, sourceLng, destination, destLat, destLng, departureTime, availableSeats, pricePerSeat, parcelAllowed, polyline, distanceKm, durationMin, } = req.body;
        const travelerId = req.user?.id;
        if (!travelerId) {
            return res.status(401).json({ error: 'Unauthorized: missing user context' });
        }
        const { data: trip, error } = await supabase_js_1.supabaseAdmin
            .from('trips')
            .insert([{
                traveler_id: travelerId,
                vehicle_id: vehicleId || null,
                source,
                source_lat: sourceLat,
                source_lng: sourceLng,
                destination,
                dest_lat: destLat,
                dest_lng: destLng,
                departure_time: departureTime,
                available_seats: availableSeats,
                price_per_seat: pricePerSeat,
                parcel_allowed: parcelAllowed,
                polyline: polyline || null,
                distance_km: distanceKm || null,
                duration_min: durationMin || null,
                status: 'active',
            }])
            .select('*, traveler:users!trips_traveler_id_fkey(*)')
            .single();
        if (error)
            throw error;
        return res.status(201).json({ success: true, trip });
    }
    catch (error) {
        next(error);
    }
}
async function searchTrips(req, res, next) {
    try {
        // Basic search of active trips
        const { data: trips, error } = await supabase_js_1.supabaseAdmin
            .from('trips')
            .select('*, traveler:users!trips_traveler_id_fkey(*)')
            .eq('status', 'active')
            .order('departure_time', { ascending: true });
        if (error)
            throw error;
        return res.status(200).json({ success: true, trips });
    }
    catch (error) {
        next(error);
    }
}
async function getTrip(req, res, next) {
    try {
        const { id } = req.params;
        const { data: trip, error } = await supabase_js_1.supabaseAdmin
            .from('trips')
            .select(`
        *,
        traveler:users!trips_traveler_id_fkey(*),
        vehicle:vehicles(*),
        trip_requests(
          *,
          passenger:users!trip_requests_passenger_id_fkey(*)
        )
      `)
            .eq('id', id)
            .single();
        if (error)
            throw error;
        if (!trip) {
            return res.status(404).json({ error: 'Trip not found' });
        }
        return res.status(200).json({ success: true, trip });
    }
    catch (error) {
        next(error);
    }
}
async function updateTripStatus(req, res, next) {
    try {
        const { id } = req.params;
        const { status } = req.body;
        const { data: trip, error } = await supabase_js_1.supabaseAdmin
            .from('trips')
            .update({ status, updated_at: new Date().toISOString() })
            .eq('id', id)
            .select('*, traveler:users!trips_traveler_id_fkey(*)')
            .single();
        if (error)
            throw error;
        return res.status(200).json({ success: true, trip });
    }
    catch (error) {
        next(error);
    }
}
async function updateLocation(req, res, next) {
    try {
        const { id } = req.params;
        const { lat, lng } = req.body;
        if (lat === undefined || lng === undefined) {
            return res.status(400).json({ error: 'lat and lng coordinates are required' });
        }
        const { data: trip, error } = await supabase_js_1.supabaseAdmin
            .from('trips')
            .update({
            current_lat: lat,
            current_lng: lng,
            updated_at: new Date().toISOString()
        })
            .eq('id', id)
            .select('*, traveler:users!trips_traveler_id_fkey(*)')
            .single();
        if (error)
            throw error;
        return res.status(200).json({ success: true, trip });
    }
    catch (error) {
        next(error);
    }
}
