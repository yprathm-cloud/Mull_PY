#!/bin/bash
# Wrapper script for pytest that mutmut will call
# This ignores test directories that require heavy dependencies
python3 -m pytest \
  --ignore=frigate/test/http_api \
  --ignore=frigate/test/gpu \
  "$@" \
  --tb=short -q
