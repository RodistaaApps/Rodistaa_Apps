# Shipments UI Guide

This document explains how the compact Shipments Dashboard and Shipment Detail experience are structured and how to integrate them with real services.

## Components

| Path | Purpose |
| --- | --- |
| `lib/screens/shipments_dashboard.dart` | Master two-pane layout (list + live map + detail view). |
| `lib/screens/shipment_detail_page.dart` | Full detail page (also embeds inside dashboard). |
| `lib/widgets/shipment_card_compact.dart` | High-density card used in dashboard list. |
| `lib/widgets/live_map_preview.dart` | Map placeholder with route polyline and markers. |
| `lib/widgets/shipment_timeline.dart` | Step-by-step visual timeline with action hooks. |
| `lib/widgets/shipment_checklist.dart` | Operator checklist with offline-safe state. |
| `lib/widgets/driver_truck_card.dart` | Driver + truck quick contact card. |
| `lib/widgets/alerts_bar.dart` | Sticky alert banner for active exceptions. |
| `lib/screens/shipments_filters_modal.dart` | Nearby/filter modal with mock map search. |

All text uses **Times New Roman** and CTAs use **Rodistaa Red `#C90D0D`**.

## Integrating Services

The UI talks to lightweight service stubs under `lib/services/`:

```dart
final shipmentService = ShipmentService.instance;
await shipmentService.markStep(shipmentId: id, step: ShipmentStep.loaded);
```

Replace the stubs with real REST/WebSocket calls by wiring:

1. **ShipmentService** → `POST /shipments/{id}/steps`, `PATCH /shipments/{id}/checklist`.
2. **PaymentsService** → `POST /shipments/{id}/payments/request` and `POST /shipments/{id}/payments/cash`.
3. **RealtimeService** → Subscribe to your WebSocket topic; emit `ShipmentLocation` updates to rebuild the map and last-ping banner.

Providers (e.g., `ShipmentProvider`) can be refreshed after each mutation to reflect live data.

## Tests

- `test/widgets/shipment_card_test.dart` covers rendering/status states for the compact card.
- `test/screens/shipment_detail_test.dart` drives the “Mark as Loaded” flow (weight + proof) and expects success feedback.

Run locally:

```sh
flutter test test/widgets/shipment_card_test.dart
flutter test test/screens/shipment_detail_test.dart
```

## Manual QA Checklist

1. **Dashboard density** – At least 6 shipment cards visible on a 1080p viewport; status + ETA chips present.
2. **Map focus** – Selecting a card on desktop highlights map + opens detail pane.
3. **Mobile navigation** – Tapping a card pushes `/shipment/:id` full screen.
4. **Timeline editing** – “Mark complete” buttons advance steps and show audit SnackBars.
5. **Mark as Loaded** – Requires weight + proof; snackbar confirms success.
6. **Tracking toggle** – Start/Stop Live Tracking updates CTA label and shows toast.
7. **Payments card** – “Request payment” + “Record cash” buttons show success acknowledgements.
8. **Filters modal** – Search, status chips, radius + tyre sliders all respond and update provider filter.
9. **Accessibility** – Buttons ≥44px, icons have semantics, Times New Roman everywhere.

Capture desktop/tablet/phone screenshots plus a GIF of the “Mark as Loaded” flow for PR review.

