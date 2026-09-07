# Testing Guide for Frigate

This document explains how to set up, run, and write tests for the Frigate project.

## Quick Start

### Install Test Dependencies
```bash
pip install -r requirements-test.txt
```

### Run All Tests
```bash
pytest
```

### Run Tests with Coverage Report
```bash
pytest --cov=frigate --cov-report=html
```

### Run Specific Test File
```bash
pytest frigate/test/test_config.py
```

### Run Specific Test
```bash
pytest frigate/test/test_config.py::TestConfig::test_config_parsing
```

### Run Tests Matching a Pattern
```bash
pytest -k "test_config" -v
```

### Run Only Fast Tests (skip slow tests)
```bash
pytest -m "not slow"
```

### Run Tests in Parallel
```bash
pip install pytest-xdist
pytest -n auto
```

## Test Structure

Tests are organized in `frigate/test/` directory:

```
frigate/
├── test/
│   ├── test_config.py           # Config-related tests
│   ├── test_camera_*.py         # Camera-related tests
│   ├── test_motion_*.py         # Motion detection tests
│   ├── http_api/                # API endpoint tests
│   │   ├── test_http_auth.py
│   │   ├── test_http_event.py
│   │   └── ...
│   └── __init__.py
├── __init__.py
├── config.py
├── models.py
└── ...
```

## Writing Tests

### Example Unit Test
```python
import unittest
from unittest.mock import patch, MagicMock
from frigate.config import FrigateConfig

class TestMyFeature(unittest.TestCase):
    def setUp(self):
        """Set up test fixtures before each test method"""
        self.config_dict = {
            "mqtt": {"host": "mqtt"},
            "cameras": {...}
        }

    def tearDown(self):
        """Clean up after each test method"""
        pass

    def test_feature_works(self):
        """Test that feature X works correctly"""
        result = some_function()
        self.assertEqual(result, expected_value)

    @patch('frigate.module.external_function')
    def test_with_mock(self, mock_func):
        """Test using mocked external dependency"""
        mock_func.return_value = "mocked"
        result = my_function()
        mock_func.assert_called_once()

    def test_error_handling(self):
        """Test error cases"""
        with self.assertRaises(ValueError):
            invalid_function()
```

### Best Practices

1. **One test per behavior**
   ```python
   def test_config_accepts_valid_input(self):
       # Good: Tests one thing
   
   # Bad: Tests multiple things
   # def test_config_validates_and_loads():
   ```

2. **Use descriptive names**
   ```python
   def test_motion_detector_returns_true_when_motion_detected(self):
       # Good: Clear what is being tested
   
   # Bad: 
   # def test_motion():
   ```

3. **Use mocks for external dependencies**
   ```python
   @patch('frigate.camera.FfmpegRunner')
   def test_camera_init(self, mock_ffmpeg):
       # Good: Isolates the unit being tested
   ```

4. **Use setup/teardown for common setup**
   ```python
   def setUp(self):
       self.config = self.load_test_config()
       self.camera = Camera(self.config)
   ```

5. **Mark slow tests**
   ```python
   @unittest.skip("Slow test - run manually")
   def test_long_running_operation(self):
       pass
   ```

## Coverage Reports

After running tests with coverage:

1. **Terminal Report** (automatic)
   ```
   Name                                    Stmts   Miss  Cover
   -----------------------------------------------------------
   frigate/__init__.py                        5      0   100%
   frigate/config.py                        450     45    90%
   ```

2. **HTML Report** (detailed)
   ```bash
   pytest --cov=frigate --cov-report=html
   # Open: htmlcov/index.html in your browser
   ```

3. **Coverage Targets**
   - Critical modules: 90%+
   - Core logic: 80%+
   - Utilities: 70%+

## CI/CD Integration

Tests run automatically on:
- ✅ Every push to `dev` or `master`
- ✅ Every pull request
- ✅ On workflow dispatch (manual trigger)

Coverage reports are uploaded to Codecov.

To manually trigger tests:
```bash
gh workflow run tests.yml
```

## Troubleshooting

### Tests fail with import errors
```bash
# Reinstall dependencies
pip install -r docker/main/requirements.txt
pip install -r requirements-test.txt
```

### Mock not working
```python
# Import the path where it's used, not where it's defined
from unittest.mock import patch

@patch('frigate.camera.FfmpegRunner')  # Correct
# NOT: @patch('frigate.ffmpeg.FfmpegRunner')
```

### Test is too slow
```python
# Mark as slow and skip by default
@unittest.skip("Too slow for CI")
def test_slow_operation(self):
    pass

# Or use timeout
pytest.mark.timeout(30)
```

## Adding New Tests

1. Create test file in `frigate/test/test_*.py`
2. Follow existing test structure
3. Use descriptive names
4. Add mocks for external dependencies
5. Run locally: `pytest frigate/test/test_yourtest.py`
6. Check coverage: `pytest --cov=frigate`

## Resources

- [pytest documentation](https://docs.pytest.org/)
- [unittest.mock documentation](https://docs.python.org/3/library/unittest.mock.html)
- [Coverage.py documentation](https://coverage.readthedocs.io/)
