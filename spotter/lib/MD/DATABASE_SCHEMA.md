# Database Schema

## Users

id
name
phone
email
profile_image
rating
role
created_at

---

## DriverVerification

id
user_id
dl_number
dl_image
verification_status

---

## Vehicles

id
user_id
vehicle_type
vehicle_number
vehicle_model
rc_image
verification_status

---

## Trips

id
traveler_id
source
destination
departure_time
available_seats
price_per_seat
parcel_allowed
status

---

## TripRequests

id
trip_id
passenger_id
status

---

## Parcels

id
sender_id
traveler_id
weight
description
photo
pickup_otp
delivery_otp
status

---

## Reviews

id
reviewer_id
reviewed_user_id
rating
comment