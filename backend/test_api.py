#!/usr/bin/env python
"""
Script de test complet de l'API HansEco
Usage: python test_api.py
"""

import requests
import json
import sys
from datetime import datetime

BASE_URL = "http://localhost:8000"

class Colors:
    """ANSI color codes"""
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

def print_header(text):
    """Print colored header"""
    print(f"\n{Colors.BOLD}{Colors.CYAN}{'='*60}{Colors.RESET}")
    print(f"{Colors.BOLD}{Colors.CYAN}{text}{Colors.RESET}")
    print(f"{Colors.BOLD}{Colors.CYAN}{'='*60}{Colors.RESET}\n")

def print_test(test_name):
    """Print test name"""
    print(f"\n{Colors.BOLD}{Colors.MAGENTA}🧪 {test_name}{Colors.RESET}")
    print(f"{Colors.YELLOW}{'-'*60}{Colors.RESET}")

def print_response(response, show_body=True):
    """Pretty print response"""
    status_code = response.status_code

    # Color based on status code
    if 200 <= status_code < 300:
        color = Colors.GREEN
        icon = "✅"
    elif 400 <= status_code < 500:
        color = Colors.YELLOW
        icon = "⚠️"
    else:
        color = Colors.RED
        icon = "❌"

    print(f"{color}{icon} Status: {status_code}{Colors.RESET}")

    if show_body:
        try:
            data = response.json()
            print(f"{Colors.BLUE}Response:{Colors.RESET}")
            print(json.dumps(data, indent=2))
        except:
            print(f"{Colors.BLUE}Response:{Colors.RESET}")
            print(response.text[:500])

    print(f"{Colors.YELLOW}{'-'*60}{Colors.RESET}")

def test_server_health():
    """Test if server is running"""
    print_test("Test 0: Server Health Check")
    try:
        response = requests.get(f"{BASE_URL}/admin/", timeout=5)
        if response.status_code == 200:
            print(f"{Colors.GREEN}✅ Server is running!{Colors.RESET}")
            return True
        else:
            print(f"{Colors.RED}❌ Server returned status: {response.status_code}{Colors.RESET}")
            return False
    except requests.exceptions.ConnectionError:
        print(f"{Colors.RED}❌ Cannot connect to server at {BASE_URL}{Colors.RESET}")
        print(f"{Colors.YELLOW}💡 Make sure to run: python manage.py runserver{Colors.RESET}")
        return False
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.RESET}")
        return False

def test_register():
    """Test user registration"""
    print_test("Test 1: User Registration")
    url = f"{BASE_URL}/api/auth/register/"

    # Generate unique email based on timestamp
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    data = {
        "email": f"test_{timestamp}@example.com",
        "password": "TestPassword123",
        "first_name": "Test",
        "last_name": "User"
    }

    print(f"{Colors.BLUE}Request URL:{Colors.RESET} {url}")
    print(f"{Colors.BLUE}Request Data:{Colors.RESET}")
    print(json.dumps(data, indent=2))

    try:
        response = requests.post(url, json=data)
        print_response(response)

        if response.status_code in [200, 201]:
            return response.json()
        else:
            return None
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.RESET}")
        return None

def test_login(email=None, password=None):
    """Test user login"""
    print_test("Test 2: User Login")
    url = f"{BASE_URL}/api/auth/login/"

    if not email or not password:
        # Use default test credentials
        email = "admin@hanseco.com"
        password = "admin123"

    data = {
        "email": email,
        "password": password
    }

    print(f"{Colors.BLUE}Request URL:{Colors.RESET} {url}")
    print(f"{Colors.BLUE}Request Data:{Colors.RESET}")
    print(json.dumps(data, indent=2))

    try:
        response = requests.post(url, json=data)
        print_response(response)

        if response.status_code == 200:
            return response.json()
        else:
            return None
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.RESET}")
        return None

def test_profile(access_token):
    """Test getting user profile"""
    print_test("Test 3: Get User Profile (Protected Route)")
    url = f"{BASE_URL}/api/auth/me/"
    headers = {"Authorization": f"Bearer {access_token}"}

    print(f"{Colors.BLUE}Request URL:{Colors.RESET} {url}")
    print(f"{Colors.BLUE}Headers:{Colors.RESET}")
    print(f"Authorization: Bearer {access_token[:30]}...{access_token[-10:]}")

    try:
        response = requests.get(url, headers=headers)
        print_response(response)

        if response.status_code == 200:
            return response.json()
        else:
            return None
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.RESET}")
        return None

def test_refresh_token(refresh_token):
    """Test token refresh"""
    print_test("Test 4: Refresh JWT Token")
    url = f"{BASE_URL}/api/oauth/token/refresh/"
    data = {"refresh": refresh_token}

    print(f"{Colors.BLUE}Request URL:{Colors.RESET} {url}")
    print(f"{Colors.BLUE}Refresh Token:{Colors.RESET} {refresh_token[:30]}...{refresh_token[-10:]}")

    try:
        response = requests.post(url, json=data)
        print_response(response)

        if response.status_code == 200:
            return response.json()
        else:
            return None
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.RESET}")
        return None

def test_products():
    """Test getting products list"""
    print_test("Test 5: Get Products List")
    url = f"{BASE_URL}/api/products/"

    print(f"{Colors.BLUE}Request URL:{Colors.RESET} {url}")

    try:
        response = requests.get(url)
        print_response(response, show_body=False)

        if response.status_code == 200:
            data = response.json()
            print(f"{Colors.GREEN}✅ Found {len(data.get('results', []))} products{Colors.RESET}")

            # Show first product if exists
            if data.get('results') and len(data['results']) > 0:
                print(f"\n{Colors.BLUE}First Product:{Colors.RESET}")
                print(json.dumps(data['results'][0], indent=2))

            return data
        else:
            return None
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.RESET}")
        return None

def test_protected_route_without_token():
    """Test accessing protected route without token"""
    print_test("Test 6: Access Protected Route Without Token (Should Fail)")
    url = f"{BASE_URL}/api/auth/me/"

    print(f"{Colors.BLUE}Request URL:{Colors.RESET} {url}")
    print(f"{Colors.BLUE}Headers:{Colors.RESET} None (no Authorization header)")

    try:
        response = requests.get(url)
        print_response(response)

        if response.status_code == 401:
            print(f"{Colors.GREEN}✅ Correctly returned 401 Unauthorized{Colors.RESET}")
        else:
            print(f"{Colors.YELLOW}⚠️ Expected 401, got {response.status_code}{Colors.RESET}")
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.RESET}")

def test_invalid_credentials():
    """Test login with invalid credentials"""
    print_test("Test 7: Login With Invalid Credentials (Should Fail)")
    url = f"{BASE_URL}/api/auth/login/"
    data = {
        "email": "wrong@example.com",
        "password": "WrongPassword123"
    }

    print(f"{Colors.BLUE}Request URL:{Colors.RESET} {url}")
    print(f"{Colors.BLUE}Request Data:{Colors.RESET}")
    print(json.dumps(data, indent=2))

    try:
        response = requests.post(url, json=data)
        print_response(response)

        if response.status_code in [400, 401]:
            print(f"{Colors.GREEN}✅ Correctly rejected invalid credentials{Colors.RESET}")
        else:
            print(f"{Colors.YELLOW}⚠️ Expected 400/401, got {response.status_code}{Colors.RESET}")
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.RESET}")

def main():
    """Main test runner"""
    print_header("🚀 HansEco Backend API Test Suite")
    print(f"{Colors.CYAN}Testing API at: {BASE_URL}{Colors.RESET}\n")

    # Test 0: Server Health
    if not test_server_health():
        print(f"\n{Colors.RED}❌ Server is not running. Exiting tests.{Colors.RESET}")
        sys.exit(1)

    # Test 1: Register
    register_data = test_register()

    # Test 2: Login (try with registered user, fallback to admin)
    if register_data and 'user' in register_data:
        login_data = test_login(
            register_data['user']['email'],
            "TestPassword123"
        )
    else:
        print(f"\n{Colors.YELLOW}⚠️ Registration failed, trying admin login{Colors.RESET}")
        login_data = test_login()

    # Tests requiring authentication
    if login_data and 'access' in login_data:
        access_token = login_data['access']

        # Test 3: Get Profile
        test_profile(access_token)

        # Test 4: Refresh Token
        if 'refresh' in login_data:
            new_tokens = test_refresh_token(login_data['refresh'])
            if new_tokens and 'access' in new_tokens:
                print(f"\n{Colors.GREEN}✅ Successfully refreshed token{Colors.RESET}")
                print(f"{Colors.BLUE}New Access Token:{Colors.RESET} {new_tokens['access'][:50]}...")
    else:
        print(f"\n{Colors.RED}❌ Cannot proceed with authenticated tests (no access token){Colors.RESET}")

    # Test 5: Products (public endpoint)
    test_products()

    # Test 6: Protected route without token
    test_protected_route_without_token()

    # Test 7: Invalid credentials
    test_invalid_credentials()

    # Summary
    print_header("📊 Test Summary")
    print(f"{Colors.GREEN}✅ Test suite completed!{Colors.RESET}")
    print(f"{Colors.CYAN}Check the results above for any failures.{Colors.RESET}\n")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n\n{Colors.YELLOW}⚠️ Tests interrupted by user{Colors.RESET}")
        sys.exit(0)
    except Exception as e:
        print(f"\n{Colors.RED}❌ Unexpected error: {e}{Colors.RESET}")
        sys.exit(1)
