# Timer Screen UI Description

## Main Timer Screen Layout

```
┌─────────────────────────────────────────┐
│ ◉ Pomodoro    ◯ カウントアップ     ⚙️    │  ← Mode Switch & Settings
├─────────────────────────────────────────┤
│                                         │
│              🔥 作業時間                 │  ← Phase Indicator (Pomodoro)
│                                         │
│        ╭─────────────────────╮         │
│       ╱                     ╲        │
│      ╱        25:00         ╲       │  ← Timer Circle with Progress
│     ╱                       ╲      │
│    ╱          ⏰             ╲     │
│   ╱                         ╲    │
│  ╱___________________________╲   │
│  ╲                         ╱   │
│   ╲_________________________╱    │
│                                         │
│      ⟲        ▶️        ⏭️            │  ← Controls: Reset, Play, Skip
│                                         │
│  ┌─────────────────────────────────┐   │
│  │         セッション進捗           │   │  ← Progress Info (Pomodoro)
│  │   現在サイクル: 1/4              │   │
│  │   完了サイクル: 0                │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

## Settings Screen Layout

```
┌─────────────────────────────────────────┐
│ タイマー設定                       ✕    │  ← Header with Close
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 作業時間                        │   │
│  │ 集中して作業する時間             │   │
│  │                                 │   │
│  │   ➖    25 分    ➕             │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 短い休憩                        │   │
│  │ 作業の間の短い休憩時間           │   │
│  │                                 │   │
│  │   ➖     5 分    ➕             │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 長い休憩                        │   │
│  │ 複数サイクル後の長い休憩時間     │   │
│  │                                 │   │
│  │   ➖    15 分    ➕             │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 長い休憩までのサイクル数         │   │
│  │ 何回の作業サイクル後に長い休憩か │   │
│  │                                 │   │
│  │   ➖   4 サイクル   ➕          │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │        設定を保存               │   │  ← Save Button
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

## Count-up Timer Layout

```
┌─────────────────────────────────────────┐
│ ◯ Pomodoro    ◉ カウントアップ     ⚙️    │  ← Mode Switch & Settings
├─────────────────────────────────────────┤
│                                         │
│                                         │
│        ╭─────────────────────╮         │
│       ╱                     ╲        │
│      ╱        05:23         ╲       │  ← Timer Circle (no progress)
│     ╱                       ╲      │
│    ╱        経過時間          ╲     │
│   ╱                         ╲    │
│  ╱___________________________╲   │
│  ╲                         ╱   │
│   ╲_________________________╱    │
│                                         │
│             ⟲        ⏸️               │  ← Controls: Reset, Pause
│                                         │
│                                         │
│                                         │
│                                         │
└─────────────────────────────────────────┘
```

## Color Scheme

### Pomodoro Mode
- **Work Phase**: 
  - Accent color (pink/red) for energy and focus
  - Progress ring: `Theme.colorScheme.accentColor`
  - Phase indicator: Red background with work icon
  
- **Break Phase**:
  - Info color (blue) for calm and relaxation  
  - Progress ring: `Theme.colorScheme.infoColor`
  - Phase indicator: Blue background with coffee icon

### Count-up Mode
- **Neutral Colors**: 
  - White/transparent elements
  - No progress indication
  - Clean, minimal appearance

### Universal Elements
- **Background**: App's gradient system (`backgroundGradient`)
- **Controls**: White buttons with transparency and shadows
- **Text**: White text with varying opacity levels
- **Settings**: Semi-transparent containers with borders

## Interactive Elements

### Mode Switch
- Toggle button with smooth transition animation
- Selected state highlighted with background
- Immediate mode switching when tapped

### Timer Circle
- Large, prominent display for easy reading
- Progress ring only visible in Pomodoro mode
- Tabular figures for consistent digit spacing

### Control Buttons
- Play/Pause: Large primary button (72px)
- Reset: Secondary button (56px) 
- Skip: Secondary button (56px), Pomodoro only
- Visual feedback on press with shadow animation

### Settings Controls
- Plus/minus buttons for each setting
- Immediate value updates
- Range validation (prevents invalid values)
- Save button applies all changes at once

## Accessibility Features

### Screen Reader Support
- Semantic labels for all interactive elements
- Progress announcements for timer updates
- Phase transition announcements

### Touch Targets
- Minimum 44pt touch targets for all buttons
- Generous spacing between interactive elements
- Clear visual feedback for button states

### Visual Accessibility
- High contrast text on gradient backgrounds
- Clear visual hierarchy with typography
- Color coding supplemented with icons and text
- No reliance on color alone for information

## Responsive Design

### Layout Adaptation
- Scales appropriately for different screen sizes
- Maintains proportions across devices
- SafeArea handling for notched devices

### Typography Scaling
- Uses relative font sizes
- Maintains readability at different system font sizes
- Preserves visual hierarchy across scales