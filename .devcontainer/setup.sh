#!/bin/bash

echo "🚀 Setting up Frappe development environment..."

# Update system
apt update && apt upgrade -y

# Install system dependencies
apt install -y curl wget git build-essential software-properties-common
apt install -y python3-dev python3-pip python3-setuptools python3-venv
apt install -y mariadb-server mariadb-client redis-server
apt install -y wkhtmltopdf

# Start services
service mariadb start
service redis-server start

# Configure MariaDB
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'admin123';"
mysql -e "CREATE USER 'frappe'@'localhost' IDENTIFIED BY 'frappe123';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'frappe'@'localhost' WITH GRANT OPTION;"
mysql -e "FLUSH PRIVILEGES;"

# Install frappe-bench
pip3 install frappe-bench

# Create workspace directory
mkdir -p /workspace/frappe-development
cd /workspace/frappe-development

# Initialize bench
echo "⚙️  Initializing Frappe bench..."
bench init furlink-bench --frappe-branch version-14

# Navigate to bench
cd furlink-bench

# Create site
echo "🏗️  Creating your Furlink site..."
bench new-site furlink.localhost --db-name furlink_db --mariadb-root-password admin123 --admin-password admin123

# Set as default site
bench use furlink.localhost

# Create custom app
echo "📱 Creating Furlink app..."
bench new-app furlink --app-name "Furlink Pet Services" --app-description "Pet grooming booking platform"

# Install app on site
bench --site furlink.localhost install-app furlink

# Enable developer mode
bench --site furlink.localhost set-config developer_mode 1
bench --site furlink.localhost clear-cache

# Set up auto-start services
echo "service mariadb start" >> /root/.bashrc
echo "service redis-server start" >> /root/.bashrc
echo "cd /workspace/frappe-development/furlink-bench" >> /root/.bashrc

echo "✅ Frappe setup complete!"
echo ""
echo "🎉 Your Furlink platform is ready!"
echo ""
echo "To start development:"
echo "1. cd /workspace/frappe-development/furlink-bench"
echo "2. bench start"
echo ""
echo "Then access your site at the forwarded port 8000"
echo "Login: Administrator"
echo "Password: admin123"
