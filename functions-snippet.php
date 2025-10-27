<?php
// Add this code to your WordPress theme's functions.php file

// Enqueue About Us page styles
function hsdigistore_about_us_styles() {
    // Only load on the About Us page
    if (is_page_template('about-us-template.php') || is_page('about-us') || is_page('about')) {
        wp_enqueue_style(
            'about-us-styles',
            get_template_directory_uri() . '/css/about-us-styles.css',
            array(),
            '1.0.0'
        );
        
        // Enqueue Google Fonts
        wp_enqueue_style(
            'google-fonts-inter',
            'https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap',
            array(),
            null
        );
        
        // Enqueue Font Awesome for icons (optional - you can use the emoji icons instead)
        wp_enqueue_style(
            'font-awesome',
            'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css',
            array(),
            '6.0.0'
        );
    }
}
add_action('wp_enqueue_scripts', 'hsdigistore_about_us_styles');

// Add custom body class for About Us page
function hsdigistore_about_us_body_class($classes) {
    if (is_page_template('about-us-template.php') || is_page('about-us') || is_page('about')) {
        $classes[] = 'about-us-page-body';
    }
    return $classes;
}
add_filter('body_class', 'hsdigistore_about_us_body_class');

// Add viewport meta tag for better mobile responsiveness
function hsdigistore_viewport_meta() {
    echo '<meta name="viewport" content="width=device-width, initial-scale=1.0">';
}
add_action('wp_head', 'hsdigistore_viewport_meta');
?>