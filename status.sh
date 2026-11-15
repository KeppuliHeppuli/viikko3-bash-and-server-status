
#!/usr/bin/env bash

# Week 3 - Server Status Report

set -e

OUTPUT="/var/www/viikko3/index.html"

# Collect server information
REPORT_TIME=$(date '+%Y-%m-%d %H:%M:%S %Z (%z)')
UPTIME=$(uptime -p)
DISK_USAGE=$(df -P / | awk 'NR==2 {gsub(/%/, "", $5); print $5}')
TOTAL_RAM=$(free -m | awk '/^Mem:/ {print $2}')
AVAILABLE_RAM=$(free -m | awk '/^Mem:/ {print $7}')

# Determine disk status
check_disk_status() {
    local usage=$1

    if [ "$usage" -ge 80 ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}

DISK_STATUS=$(check_disk_status "$DISK_USAGE")

if [ "$DISK_STATUS" = "WARNING" ]; then
    STATUS_COLOR="#f87171"
    STATUS_BG="#450a0a"
else
    STATUS_COLOR="#86efac"
    STATUS_BG="#14532d"
fi
# Generate HTML report

cat > "$OUTPUT" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Week 3 | Server Status</title>
    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            padding: 50px 20px;
            background: #0f172a;
            color: #f8fafc;
            font-family: Arial, sans-serif;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
        }

        .subtitle {
            color: #93c5fd;
            font-size: 13px;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        h1 {
            font-size: 38px;
            margin: 10px 0;
        }

        .description {
            color: #94a3b8;
        }

        .badge {
            background: $STATUS_BG;
            color: $STATUS_COLOR;
            padding: 10px 20px;
            border-radius: 30px;
            font-weight: bold;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .card {
            background: #1e293b;
            padding: 28px;
            border-radius: 14px;
            border: 1px solid #334155;
        }

        .card h2 {
            color: #94a3b8;
            font-size: 15px;
            font-weight: normal;
            margin: 0 0 16px;
        }

        .value {
            font-size: 30px;
            font-weight: bold;
        }

        .disk {
            margin-top: 20px;
        }

        .progress {
            background: #334155;
            height: 12px;
            border-radius: 20px;
            overflow: hidden;
            margin-top: 20px;
        }

        .progress-bar {
            width: $DISK_USAGE%;
            height: 100%;
            background: $STATUS_COLOR;
            border-radius: 20px;
        }

        .footer {
            text-align: center;
            color: #94a3b8;
            margin-top: 35px;
            font-size: 14px;
        }

        a { color: #93c5fd; }

        @media (max-width: 600px) {
            .header { align-items: flex-start; }
            h1 { font-size: 28px; }
            .grid { grid-template-columns: 1fr; }
            .value { font-size: 25px; }
        }
    </style>
</head>
<body>
    <main class="container">
        <header class="header">
            <div>
                <div class="subtitle">Week 03 / Linux Server</div>
                <h1>Server Status</h1>
                <p class="description">
                    Automatically generated system monitoring report
                </p>
            </div>
            <div class="badge">$DISK_STATUS</div>
        </header>

        <section class="grid">
            <div class="card">
                <h2>Server Uptime</h2>
                <div class="value">$UPTIME</div>
            </div>

            <div class="card">
                <h2>Disk Usage</h2>
                <div class="value">$DISK_USAGE%</div>
            </div>

            <div class="card">
                <h2>Total RAM</h2>
                <div class="value">$TOTAL_RAM MiB</div>
            </div>

            <div class="card">
                <h2>Available RAM</h2>
                <div class="value">$AVAILABLE_RAM MiB</div>
            </div>
        </section>

        <section class="card disk">
            <h2>Root Filesystem ( / )</h2>
            <div class="value">$DISK_USAGE% used</div>
            <div class="progress">
                <div class="progress-bar"></div>
            </div>
            <p class="description">
                Status: $DISK_STATUS — Warning threshold: 80%
            </p>
        </section>

        <footer class="footer">
            <p>Last generated: $REPORT_TIME</p>
            <p>Powered by Bash, Linux and Nginx</p>
            <p>
                <a href="https://github.com/KeppuliHeppuli">
                    GitHub
                </a>
            </p>
        </footer>
    </main>
</body>
</html>
EOF

echo "Report generated successfully: $OUTPUT"
