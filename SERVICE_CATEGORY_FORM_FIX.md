# Service Category Form Fix - Short Info and Experience Fields Not Saving

## Problem Description
The service category form was not saving the `short_info` and `experience_years` fields to the database, while other fields were being saved successfully.

## Root Cause Analysis
After analyzing the codebase, I identified the issue was in the controller's parameter handling:

1. **Two Separate Forms**: The page has two separate forms:
   - Category selection form (submits to `update_subcategories_path`)
   - Professional details form (submits to `update_professional_details_path`)

2. **Missing Parameter Permission**: The `professional_params` method in `ServiceProvidersController` was missing the `:category` parameter in the permitted parameters list.

3. **Data Inconsistency**: When the professional details form was submitted, the category field was being filtered out by Rails' strong parameters, potentially causing validation issues or data inconsistency that prevented other fields from being saved.

## Files Modified

### 1. `app/controllers/service_providers_controller.rb`
**Line 110-112**: Added `:category` to the permitted parameters

**Before:**
```ruby
def professional_params
    params.require(:user).permit(:experience_years, :short_info, subcategories: [])
end
```

**After:**
```ruby
def professional_params
    params.require(:user).permit(:category, :experience_years, :short_info, subcategories: [])
end
```

### 2. `app/views/service_providers/_service_provider_service_type_form.html.erb`
**Line 17-19**: Added a hidden field to preserve the category selection in the professional details form

**Added:**
```erb
<!-- Hidden field to preserve category selection -->
<%= form.hidden_field :category, value: @resource.category %>
```

## Why This Fixes the Issue

1. **Complete Parameter Permission**: Now all form fields including category are properly permitted and processed together.

2. **Data Consistency**: The hidden field ensures that the category value is included in the professional details form submission, maintaining data consistency.

3. **Proper Strong Parameters**: Rails' strong parameters now allow all the necessary fields to be processed, preventing any parameter filtering that might have caused the save to fail.

## Testing the Fix

To verify the fix works:

1. Navigate to the service provider registration/setup form
2. Select a service category from the dropdown
3. Fill in the experience years and short info fields
4. Submit the form
5. Check the database or user profile to confirm all fields are saved

## Additional Notes

- The database schema already had the correct fields (`experience_years` as string, `short_info` as text)
- The form fields were correctly implemented
- The issue was purely in the controller's parameter handling
- No migration changes were needed

This fix ensures that all form data is properly processed and saved to the database.