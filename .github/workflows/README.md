# Workflow Tests

This directory contains test workflows to validate that the reusable workflows (`danger-run.yml` and `danger-comment.yml`) work as expected.

## Test Workflows

### test-workflows.yml

The main comprehensive test workflow that validates:

- **Workflow Syntax**: Validates YAML syntax and checks that all expected inputs are defined
- **Multiple Configurations**: Tests danger-run with different Ruby versions and cache settings:
  - Default configuration
  - Custom Ruby version (3.2)
  - Without bundler cache
- **Report Generation**: Verifies that Danger reports are created with the correct structure
- **Report Validation**: Checks that generated reports contain all required fields:
  - `pr_number` (number)
  - `errors` (array)
  - `warnings` (array)
  - `messages` (array)
  - `markdowns` (array)
- **Reusable Workflow Call**: Tests that the danger-run workflow can be called as a reusable workflow

### test-danger-run.yml

Tests the `danger-run.yml` reusable workflow with various input configurations:

- Default inputs
- Custom Ruby version
- Custom artifact names
- Disabled bundler cache

Also includes artifact verification steps to ensure reports are uploaded correctly.

### test-danger-comment.yml

Tests the `danger-comment.yml` reusable workflow with:

- Default comment settings
- Custom comment title and marker
- Custom artifact names

This workflow is triggered after `test-danger-run.yml` completes.

## Running the Tests

The tests run automatically on:

- Push to `main` branch
- Pull requests
- Manual trigger via `workflow_dispatch`

### Manual Trigger

To manually run the tests:

1. Go to the Actions tab in GitHub
2. Select "Workflow Integration Tests"
3. Click "Run workflow"
4. Select the branch and click "Run workflow"

## Test Results

All test workflows provide detailed output including:

- ✓ Success indicators for passed checks
- ✗ Error messages for failed checks
- Report contents for debugging
- Summary of all test results

## Continuous Integration

These tests ensure that:

1. The reusable workflows are syntactically correct
2. All documented inputs are present and working
3. Danger reports are generated with the expected structure
4. Artifacts are uploaded and can be downloaded
5. The workflows can be successfully called from other workflows

## Troubleshooting

If tests fail:

1. Check the workflow run logs for specific error messages
2. Verify that the Dangerfile is correctly configured
3. Ensure all dependencies are properly specified in the Gemfile
4. Check that the report generation code in the Dangerfile matches the expected format
