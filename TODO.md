# TODO

## 1. Android Accessibility Layer (uiautomator2)

Replace screenshot-based UI interaction with `uiautomator2` to get structured UI data directly.

- Profile text: extracted from UI tree, no OCR/Tesseract needed
- Heart button: found by resource ID or content description, no `heart1.png` reference image needed
- Taps by element instead of hardcoded pixel coordinates — more robust across screen sizes

This eliminates the current CV stack for UI interaction entirely.

## 2. Restore Preference Gate (short-circuited)

The like/dislike decision in `main.py` is currently hardcoded to always like (`if True`).
Restore a real preference gate using one of the approaches below before going to production.

## 3. Physical Preference Filtering

Add physical attribute filtering (fitness, age, etc.) using GPT-4 Vision on profile photos.

- Send profile photo to GPT-4 Vision with a preference prompt (e.g. "rate fitness 1-5, flag if outside age range 25-35")
- Wire the score into the like/dislike decision before generating a comment
- No training data needed for this path

If API cost becomes a concern later, a local CV classifier could replace it — but would require hundreds of labeled profile photos per attribute.
