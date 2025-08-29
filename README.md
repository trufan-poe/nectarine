# Nectarine Credit Approval Web-App

A full-stack credit approval application built with Elixir/Phoenix that assesses user risk and calculates credit approval amounts.

## 🎯 Features

- **Risk Assessment**: 5-question risk scoring system
- **Credit Calculation**: Automatic credit amount calculation based on income/expenses
- **PDF Generation**: Automatic PDF creation with application details
- **Email Delivery**: PDF sent to user's email address
- **Modern UI**: Beautiful, responsive interface built with LiveView and Tailwind CSS
- **Database Storage**: PostgreSQL backend for application persistence

## 🏗️ Architecture

- **Backend**: Elixir/Phoenix with LiveView
- **Database**: PostgreSQL with Ecto
- **Frontend**: Phoenix LiveView with Tailwind CSS
- **PDF Generation**: pdf_generator library
- **Email**: Swoosh with Resend API
- **GraphQL**: Absinthe for API endpoints

## 📋 Requirements

- Elixir 1.15+
- Erlang/OTP 24+
- Docker (for PostgreSQL)
- Node.js 18+ (for Tailwind CSS)
- Resend API token (for email delivery)

## 🚀 Quick Start

### 1. Clone and Setup

```bash
git clone <your-repo-url>
cd nectarine
mix deps.get
```

### 2. Setup PostgreSQL with Docker

```bash
# Start PostgreSQL container
docker run --name postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=nectarine_dev -p 5432:5432 -d postgres:15

# Verify it's running
docker ps
```

### 3. Environment Configuration

Create a `.env` file in the project root:

```bash
# .env
export RESEND_API_KEY=your_resend_api_token_here
export DATABASE_URL=postgres://postgres:postgres@localhost:5432/nectarine_dev
```

Load the environment variables:

```bash
source .env
```

**Note**: You'll need to get a Resend API token from [resend.com](https://resend.com). Sign up for a free account and generate an API key.

### 4. Database Setup

```bash
mix ecto.setup
```

### 5. Build Frontend Assets

```bash
cd assets
npm install
./build.sh
cd ..
```

### 6. Start the Server

```bash
mix phx.server
```

### 7. Visit the Application

Open [http://localhost:4000/credit-application](http://localhost:4000/credit-application)

## 🐳 Docker Commands

```bash
# Start PostgreSQL
docker start postgres

# Stop PostgreSQL
docker stop postgres

# Remove PostgreSQL container
docker rm postgres

# View PostgreSQL logs
docker logs postgres
```

## 📱 How It Works

### Step 1: Risk Assessment
Answer 5 questions to determine your risk score:
- **Paying job**: 4 points
- **Consistent job (12 months)**: 2 points  
- **Home ownership**: 2 points
- **Car ownership**: 1 point
- **Additional income**: 2 points

**Minimum score required**: 7+ points to proceed

### Step 2: Financial Information
Provide:
- Monthly income from all sources
- Monthly expenses
- Email address

### Step 3: Credit Approval
- **Approved amount**: (Income - Expenses) × 12 months
- **PDF generated** with all application details
- **Email sent** with PDF attachment

## 🛠️ Development

### Asset Building
```bash
# Development (with watch mode)
cd assets && npm run build

# Production
cd assets && npm run build:prod
```

### Database
```bash
# Reset database
mix ecto.reset

# Run migrations
mix ecto.migrate

# Access PostgreSQL directly
docker exec -it postgres psql -U postgres -d nectarine_dev
```

### Email Preview
In development, emails are previewed at [http://localhost:4000/dev/mailbox](http://localhost:4000/dev/mailbox)

## 🔑 API Keys Required

### Resend API Token
- **Purpose**: Email delivery service
- **Get it from**: [resend.com](https://resend.com)
- **Setup**: Add to `.env` file as `RESEND_API_KEY`
- **Free tier**: 3,000 emails/month

## 📁 Project Structure

```
nectarine/
├── lib/
│   ├── nectarine/                    # Business logic
│   │   ├── credit_applications/      # Credit application schema
│   │   ├── email.ex                  # Email functionality
│   │   └── pdf_generator.ex          # PDF generation
│   └── nectarine_web/               # Web layer
│       ├── live/                     # LiveView controllers
│       ├── graphql/                  # GraphQL schema & resolvers
│       └── components/               # Layout components
├── assets/                           # Frontend assets
│   ├── css/                          # Tailwind CSS
│   ├── js/                           # JavaScript
│   └── build.sh                      # Asset build script
├── priv/                             # Static files & migrations
├── .env                              # Environment variables (create this)
└── test/                             # Test suite
```

## 🧪 Testing

```bash
mix test
```

## 📧 Contact

For questions about this implementation, contact: mashiyat@nectarinecredit.com

## 🎉 Bonus Features Implemented

- **Responsive design** for mobile and desktop
- **Professional UI/UX** with modern styling
- **Database persistence** for applications
- **GraphQL API** for extensibility
- **LiveView** for real-time interactions
- **Error handling** and validation
- **Development tools** (email preview, dashboard)

## 📄 License

This project is part of a coding exercise for Nectarine Credit.
