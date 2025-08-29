#!/bin/bash

echo "Building Nectarine assets..."

# Build CSS
echo "Building CSS..."
npx tailwindcss -i ./css/app.css -o ../priv/static/assets/app.css

# Build JavaScript
echo "Building JavaScript..."
npx esbuild js/app.js --bundle --outdir=../priv/static/assets --external:phoenix --external:phoenix_live_view

echo "Build complete! Assets are now available in ../priv/static/assets/"
