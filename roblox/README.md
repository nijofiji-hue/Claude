# Roblox Wave Animation

`WaveAnimation.client.lua` makes an R15 character wave when you press **E**.
It moves the arm from code (Motor6D `Transform`), so there is nothing to upload.

## Use it

1. In Roblox Studio, open **StarterPlayer > StarterCharacterScripts**.
2. Insert a **LocalScript**, name it `WaveAnimation`, and paste in the code.
3. Press **Play**, then press **E** to start or stop waving.

## Tweak it

Change the constants at the top of the script:

| Setting | What it does |
|---|---|
| `TOGGLE_KEY` | Key that toggles the wave |
| `WAVE_SPEED` | How fast the hand moves |
| `WAVE_AMOUNT` | How far the forearm swings |
| `ARM_RAISE` | How high the arm is lifted |
| `BLEND_SPEED` | How smoothly the wave fades in and out |

The game must use R15 avatars (Game Settings > Avatar).
