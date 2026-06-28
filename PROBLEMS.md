# Known Problems

## 1. Swipe gesture is likely wrong for advancing profiles

The swipe goes vertically upward within the screen (`50% height` → `37.5% height`), which scrolls within the current profile to see more photos/bio. On Hinge, advancing to the next person requires tapping X or the heart — not swiping. The bot is likely cycling through one profile's photos 10 times rather than visiting 10 different people.

## 2. No sleep after swipe

Screenshot is taken immediately after the swipe with no delay, so it may capture a mid-animation frame before the UI settles.

## 3. Comment is generated but never sent

The code to tap the comment field, type the comment, and send it is all commented out (main.py lines ~135–150). GPT-4 generates a comment and it gets stored, but it is never actually typed or submitted on the app.

## 4. Bot runs only 10 profiles then stops

The loop is hardcoded to 10 iterations with no restart or continuation logic. It exits after 10, requiring a manual re-run.
