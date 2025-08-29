# Frontend Assets Setup

This directory contains the frontend assets for the Nectarine Credit Approval app.

## Setup Instructions

### 1. Install Dependencies
```bash
cd assets
npm install
```

### 2. Build CSS
For development (with watch mode):
```bash
npm run build
```

For production:
```bash
npm run build:prod
```

### 3. Development Workflow
1. Start the CSS build process in watch mode: `npm run build`
2. The CSS will automatically rebuild when you make changes to `app.css`
3. The compiled CSS will be output to `../priv/static/assets/app.css`

## File Structure

- `css/app.css` - Main CSS file with Tailwind imports and custom styles
- `js/app.js` - JavaScript entry point for LiveView
- `tailwind.config.js` - Tailwind CSS configuration
- `package.json` - Node.js dependencies and build scripts

## Tailwind CSS

The app uses Tailwind CSS for styling. The configuration includes:
- Custom color palette for the Nectarine brand
- Responsive design utilities
- Custom animations and transitions
- Focus states and hover effects

## Custom Styles

Additional custom styles are defined in `app.css`:
- Background gradients
- Form styling
- Animation keyframes
- Hover effects
- Custom color schemes
