# Sandbox Utilities

This repository contains scripts and utilities for my own dev server. This sets up Caddy, multiple versions of PHP (with dev-friendly defaults) and MariaDB.

## Installation

Do not run the following script as root. It will ask you for your `sudo` password on execution.

```bash
curl -s https://raw.githubusercontent.com/liamdemafelix/sandbox/refs/heads/master/install.sh | bash
```

After setup, it will automatically reboot the server to make sure the changes have taken effect.

## License

This project is licensed under the MIT Open Source License.

```
MIT License

Copyright (c) 2025 Liam Nicolo Demafelix <hey@liam.ph>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```