#!/usr/bin/env python3
import ssl
import socket
from datetime import datetime, timezone
from email.message import EmailMessage
import smtplib

# CONFIG
DOMAINS_FILE = "domains.txt"
THRESHOLD_DAYS = 70

# Email settings (debug server)
SMTP_SERVER = "localhost"  # Debug server
SMTP_PORT = 1025           # Debug server port
SMTP_USER = "me@example.com"
ALERT_EMAIL = "you@example.com"  # Recipient (will appear in debug output)

def send_email(subject, body):
    """Send an email alert via SMTP"""
    msg = EmailMessage()
    msg.set_content(body)
    msg["Subject"] = subject
    msg["From"] = SMTP_USER
    msg["To"] = ALERT_EMAIL

    try:
        with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
            server.send_message(msg)
        print(f"✅ Email alert sent for: {subject}")
    except Exception as e:
        print(f"❌ Failed to send email: {e}")

def check_ssl(domain):
    """Check SSL certificate expiry and return days left"""
    context = ssl.create_default_context()

    with socket.create_connection((domain, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=domain) as ssock:
            cert = ssock.getpeercert()
            exp_date_str = cert["notAfter"]
            exp_date = datetime.strptime(exp_date_str, "%b %d %H:%M:%S %Y %Z").replace(tzinfo=timezone.utc)
            days_left = (exp_date - datetime.now(timezone.utc)).days
            return days_left

def main():
    try:
        with open(DOMAINS_FILE) as f:
            domains = [line.strip() for line in f if line.strip()]
    except FileNotFoundError:
        print(f"Error: File '{DOMAINS_FILE}' not found.")
        return

    for domain in domains:
        print(f"Checking SSL certificate for {domain} ...")
        try:
            days_left = check_ssl(domain)
            if days_left < 0:
                print(f"Certificate expired {-days_left} days ago")
                send_email(f"SSL Alert: {domain} expired", 
                           f"The SSL certificate for {domain} expired {-days_left} days ago!")
            elif days_left < THRESHOLD_DAYS:
                print(f"Certificate will expire in {days_left} days")
                send_email(f"SSL Alert: {domain} expiring soon", 
                           f"The SSL certificate for {domain} will expire in {days_left} days")
            else:
                print(f"Certificate will expire in {days_left} days")
        except Exception as e:
            print(f"Failed to retrieve certificate for {domain}: {e}")

        print()

if __name__ == "__main__":
    main()