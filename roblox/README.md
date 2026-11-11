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

---

# Roblox Dance Animation

`DanceAnimation.client.lua` makes an R15 character do a full-body 3D dance
when you press **G**. Every joint is moved from code, so there is nothing to upload.

The body bounces on every beat, the hips sway and the chest counter-twists,
and the head bobs. The arms switch between two moves every 8 beats:

- **Pump** — arms punch overhead, alternating left and right
- **Groove** — arms out to the sides, rolling like a wave

## Use it

1. In Roblox Studio, open **StarterPlayer > StarterCharacterScripts**.
2. Insert a **LocalScript**, name it `DanceAnimation`, and paste in the code.
3. Press **Play**, then press **G** to start or stop dancing.

## Tweak it

| Setting | What it does |
|---|---|
| `TOGGLE_KEY` | Key that toggles the dance |
| `BPM` | Dance tempo — match it to your music |
| `BEATS_PER_MOVE` | Beats before switching between moves |
| `BOUNCE_HEIGHT` | How far the body dips on each beat |
| `BLEND_SPEED` | How smoothly the dance fades in and out |
