# Termux & Linux PHP Launcher

A simple Bash script that helps you start your PHP project in Termux with just a few steps.

It automatically checks the required tools, lets you choose your project, starts the PHP server, creates a Cloudflare Tunnel, and gives you a public URL that you can open from anywhere.

No long commands. No manual setup every time.

---

# Why I Built This

Every time I wanted to test a PHP project in Termux, I had to run the same commands again and again.

- Go to the project folder
- Find the correct IP address
- Choose a port
- Start the PHP server
- Start Cloudflared
- Wait for the public URL

It worked, but it was repetitive and easy to make mistakes.

So I created this launcher to make the process simple, fast, and beginner-friendly.

---

# Purpose

The purpose of this project is to save time and make local PHP development easier in Termux.

Instead of remembering different commands, you only run one script.

The launcher does the rest.

---

# Features

- Colorful terminal interface
- Automatic dependency check
- Installs PHP if missing
- Installs Cloudflared if missing
- Installs net-tools if missing
- Creates the project directory automatically
- Lists all projects in alphabetical order
- Shows hidden folders and files
- Automatically detects your current local IP
- Option to use Localhost (127.0.0.1)
- Custom port selection
- Checks if the selected port is already in use
- Starts the PHP built-in server
- Creates a free Cloudflare Tunnel
- Displays the public URL
- Proper error handling
- Clean exit using Ctrl + C

---

# Project Directory

Place your projects inside:

```
/storage/emulated/0/Termux/
```

Example

```
Termux/
│
├── ProjectOne
├── ProjectTwo
├── MyWebsite
└── TestAPI
```

---

# Installation

Save the script as

```
/data/data/com.termux/files/home/start.sh
```

Give permission

```bash
chmod +x start.sh
```

Run

```bash
./start.sh
```

---

# How It Works

Step 1

The script checks whether the required packages are installed.

If something is missing, it installs it automatically.

Step 2

It scans the project folder and shows all available projects.

Step 3

You select the project you want to run.

Step 4

Choose either:

- Localhost (127.0.0.1)
- Your current local network IP

Step 5

Enter a port number.

If the port is already being used, the script asks for another one.

Step 6

The PHP server starts.

Step 7

Cloudflared creates a secure public tunnel.

Step 8

The script displays:

- Local URL
- Public URL

Now your project can be accessed from another device using the generated URL.

---

# Who Can Use This?

This project is useful for:

- PHP beginners
- Students
- Web developers
- Laravel learners
- API developers
- Anyone using Termux for local development

---

# Requirements

- Android device
- Termux
- Internet connection (only for Cloudflare Tunnel)
- Storage permission

---

# Example Output

```
Project : MyWebsite

Host : 127.0.0.1

Port : 8080

Local URL

http://127.0.0.1:8080

Public URL

https://example.trycloudflare.com
```

---

# Future Plans

Possible improvements:

- HTTPS custom domain support
- Multiple running projects
- QR Code for public URL
- Favorite projects
- Search projects
- Configuration file support

---

# Contributing

Ideas and improvements are always welcome.

If you find a bug or have a suggestion, feel free to open an issue or submit a pull request.

---
