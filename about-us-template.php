<?php
/*
Template Name: About Us Page
*/

get_header(); ?>

<div class="about-us-page">
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="hero-content">
                <h1 class="hero-title">About HS Digi Store</h1>
                <p class="hero-subtitle">Your trusted partner in digital solutions and e-commerce excellence</p>
                <div class="hero-stats">
                    <div class="stat-item">
                        <span class="stat-number">5+</span>
                        <span class="stat-label">Years Experience</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">500+</span>
                        <span class="stat-label">Happy Clients</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">1000+</span>
                        <span class="stat-label">Projects Completed</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Our Story Section -->
    <section class="our-story-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-6">
                    <div class="story-content">
                        <h2 class="section-title">Our Story</h2>
                        <p class="story-text">
                            Founded with a vision to bridge the gap between traditional business and digital innovation, 
                            HS Digi Store has been at the forefront of digital transformation since our inception. 
                            We started as a small team of passionate developers and have grown into a comprehensive 
                            digital solutions provider.
                        </p>
                        <p class="story-text">
                            Our journey began when we recognized the growing need for businesses to establish 
                            a strong online presence. Today, we're proud to have helped hundreds of businesses 
                            achieve their digital goals through innovative e-commerce solutions, web development, 
                            and digital marketing strategies.
                        </p>
                        <div class="story-highlights">
                            <div class="highlight-item">
                                <i class="icon-rocket"></i>
                                <span>Innovation-driven approach</span>
                            </div>
                            <div class="highlight-item">
                                <i class="icon-users"></i>
                                <span>Client-centric solutions</span>
                            </div>
                            <div class="highlight-item">
                                <i class="icon-growth"></i>
                                <span>Scalable business growth</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="story-image">
                        <img src="<?php echo get_template_directory_uri(); ?>/images/about-story.jpg" alt="Our Story" class="img-fluid">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Mission & Vision Section -->
    <section class="mission-vision-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-6">
                    <div class="mission-card">
                        <div class="card-icon">
                            <i class="icon-target"></i>
                        </div>
                        <h3 class="card-title">Our Mission</h3>
                        <p class="card-text">
                            To empower businesses with cutting-edge digital solutions that drive growth, 
                            enhance customer experiences, and create lasting value in the digital marketplace. 
                            We strive to be the catalyst that transforms your digital vision into reality.
                        </p>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="vision-card">
                        <div class="card-icon">
                            <i class="icon-eye"></i>
                        </div>
                        <h3 class="card-title">Our Vision</h3>
                        <p class="card-text">
                            To become the leading digital transformation partner, recognized for our innovation, 
                            reliability, and commitment to client success. We envision a future where every 
                            business, regardless of size, has access to world-class digital solutions.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Team Section -->
    <section class="team-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Meet Our Team</h2>
                <p class="section-subtitle">The talented individuals behind HS Digi Store's success</p>
            </div>
            <div class="team-grid">
                <div class="team-member">
                    <div class="member-image">
                        <img src="<?php echo get_template_directory_uri(); ?>/images/team-1.jpg" alt="Team Member" class="img-fluid">
                    </div>
                    <div class="member-info">
                        <h4 class="member-name">John Smith</h4>
                        <p class="member-role">CEO & Founder</p>
                        <p class="member-bio">Visionary leader with 10+ years in digital commerce</p>
                        <div class="member-social">
                            <a href="#" class="social-link"><i class="fab fa-linkedin"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                        </div>
                    </div>
                </div>
                <div class="team-member">
                    <div class="member-image">
                        <img src="<?php echo get_template_directory_uri(); ?>/images/team-2.jpg" alt="Team Member" class="img-fluid">
                    </div>
                    <div class="member-info">
                        <h4 class="member-name">Sarah Johnson</h4>
                        <p class="member-role">CTO</p>
                        <p class="member-bio">Tech expert specializing in scalable solutions</p>
                        <div class="member-social">
                            <a href="#" class="social-link"><i class="fab fa-linkedin"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-github"></i></a>
                        </div>
                    </div>
                </div>
                <div class="team-member">
                    <div class="member-image">
                        <img src="<?php echo get_template_directory_uri(); ?>/images/team-3.jpg" alt="Team Member" class="img-fluid">
                    </div>
                    <div class="member-info">
                        <h4 class="member-name">Mike Davis</h4>
                        <p class="member-role">Lead Developer</p>
                        <p class="member-bio">Full-stack developer with passion for innovation</p>
                        <div class="member-social">
                            <a href="#" class="social-link"><i class="fab fa-linkedin"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-github"></i></a>
                        </div>
                    </div>
                </div>
                <div class="team-member">
                    <div class="member-image">
                        <img src="<?php echo get_template_directory_uri(); ?>/images/team-4.jpg" alt="Team Member" class="img-fluid">
                    </div>
                    <div class="member-info">
                        <h4 class="member-name">Emily Chen</h4>
                        <p class="member-role">UX/UI Designer</p>
                        <p class="member-bio">Creative designer focused on user experience</p>
                        <div class="member-social">
                            <a href="#" class="social-link"><i class="fab fa-linkedin"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-dribbble"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Values Section -->
    <section class="values-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Our Core Values</h2>
                <p class="section-subtitle">The principles that guide everything we do</p>
            </div>
            <div class="values-grid">
                <div class="value-item">
                    <div class="value-icon">
                        <i class="icon-shield"></i>
                    </div>
                    <h4 class="value-title">Integrity</h4>
                    <p class="value-description">We operate with complete transparency and honesty in all our dealings.</p>
                </div>
                <div class="value-item">
                    <div class="value-icon">
                        <i class="icon-lightbulb"></i>
                    </div>
                    <h4 class="value-title">Innovation</h4>
                    <p class="value-description">We constantly push boundaries to deliver cutting-edge solutions.</p>
                </div>
                <div class="value-item">
                    <div class="value-icon">
                        <i class="icon-heart"></i>
                    </div>
                    <h4 class="value-title">Excellence</h4>
                    <p class="value-description">We strive for perfection in every project we undertake.</p>
                </div>
                <div class="value-item">
                    <div class="value-icon">
                        <i class="icon-handshake"></i>
                    </div>
                    <h4 class="value-title">Partnership</h4>
                    <p class="value-description">We build lasting relationships based on trust and mutual success.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container">
            <div class="cta-content">
                <h2 class="cta-title">Ready to Transform Your Business?</h2>
                <p class="cta-subtitle">Let's work together to bring your digital vision to life</p>
                <div class="cta-buttons">
                    <a href="/contact" class="btn btn-primary">Get Started</a>
                    <a href="/portfolio" class="btn btn-outline">View Our Work</a>
                </div>
            </div>
        </div>
    </section>
</div>

<?php get_footer(); ?>