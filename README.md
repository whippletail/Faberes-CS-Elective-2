# SkimWave Shop

Complete e-commerce submission for the CS Elective 2 Prelim Exam. SkimWave is a responsive Flutter shop browser with an app-wide light/dark theme and a complete shopping flow.

## Run

1. Install Flutter and confirm it with `flutter doctor`.
2. Open this folder in VS Code or Android Studio.
3. Run `flutter pub get`.
4. If platform folders are not present, run `flutter create .` once.
5. Run `flutter run`.

## Completed flow

Home product grid -> Product details -> Add to cart -> Cart quantity controls -> Checkout confirmation

## Rubric coverage

- One app-wide `ThemeData` pair (light/dark)
- Stateful app theme toggle in the Home AppBar
- Responsive `GridView.builder`: 2 phone, 3 tablet, 4 wide tablet/desktop columns
- Stateless product cards
- `Card`, `Image`, `Text`, `Scaffold`, `AppBar`, and `LayoutBuilder`
- Navigation 2.0 through `go_router`
- Responsive product details and cart layouts
- Live cart quantities, per-item subtotals, order total, and cart badge
- Checkout confirmation with itemized order summary
- Checkout route protected from an empty cart
- Clear separation between stateless display widgets and stateful interactions

Suggested Git branch: `PrelimExam`
