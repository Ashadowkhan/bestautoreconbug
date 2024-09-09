To integrate the [**waymore**](https://github.com/xnl-h4ck3r/waymore) tool into the `autorecon.sh` script, we will extend the script's functionality to give the user a choice between using `waybackurls` or `waymore` to fetch URLs. **waymore** is a more advanced URL enumeration tool that works with multiple sources (including the Wayback Machine, AlienVault, URLScan, etc.), providing more comprehensive results than `waybackurls`.

### Steps:
1. **Check if `waymore` is installed**: Ensure the script checks if `waymore` is installed.
2. **Give the user a choice**: Let the user choose between `waymore` and `waybackurls`.
3. **Process URLs with the selected tool**: Fetch URLs with either `waymore` or `waybackurls`, then continue with vulnerability scanning using `gf`.

### Updated `autorecon.sh` Script:


### Explanation of Updates:
1. **Tool Selection**:
   - The user can choose between `waybackurls` or `waymore` by providing the tool name as the second argument. If no tool is specified, it defaults to `waybackurls`.
   - The script now accepts the tool choice as an argument: `./autorecon.sh <domain-file or single-domain> [waybackurls|waymore]`.

2. **Fetching URLs**:
   - If the user selects `waymore`, the script runs the following command to fetch URLs using the `waymore` tool:
     ```bash
     waymore -i "$domain_list" -mode U > "$output_urls"
     ```
   - If the user selects `waybackurls`, it fetches URLs the same way as before with:
     ```bash
     cat "$domain_list" | waybackurls | tee "$output_urls"
     ```

3. **URL and Vulnerability Processing**:
   - After fetching the URLs, the script continues with the `gf` scanning process, as before. It searches for patterns like `sqli`, `xss`, etc., and stores the results in the `gf_results` directory.

### Usage Examples:

#### 1. Using `waybackurls` with a file:
```bash
./autorecon.sh domains.txt waybackurls
```
This will:
- Fetch URLs using `waybackurls` for the domains in `domains.txt`.
- Perform vulnerability scanning with `gf`.
- Store the results in the `gf_results` directory.

#### 2. Using `waymore` with a file:
```bash
./autorecon.sh domains.txt waymore
```
This will:
- Fetch URLs using `waymore` for the domains in `domains.txt`.
- Perform vulnerability scanning with `gf`.
- Save results in the `gf_results` directory.

#### 3. Using `waybackurls` with a single domain:
```bash
./autorecon.sh example.com waybackurls
```
This will:
- Fetch URLs from `example.com` using `waybackurls`.
- Perform vulnerability scans and save the results.

#### 4. Using `waymore` with a single domain:
```bash
./autorecon.sh example.com waymore
```
This will:
- Fetch URLs from `example.com` using `waymore`.
- Perform vulnerability scans and save the results.

### Notes:
- Ensure the script has execute permissions:
  ```bash
  chmod +x autorecon.sh
  ```
- **Install `waymore`** if you haven’t already:
  ```bash
  git clone https://github.com/xnl-h4ck3r/waymore
  cd waymore
  pip3 install -r requirements.txt
  ```
This updated version adds flexibility by letting you choose between the powerful `waymore` and the simpler `waybackurls` for fetching URLs, while still keeping the vulnerability scanning process streamlined using `gf`.
