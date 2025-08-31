🛠️ Flutter E-Commerce App
A simple e-commerce mobile app built with Flutter. The application includes essential features like user authentication, product display, shopping cart, favorites, and profile management.

For a quick walkthrough of the app and its features, check out the video guide below:

👉 <a href="https://drive.google.com/file/d/1M11gavybpGBZO54l_VoaF3rNRgetHOkd/view?usp=share_link" target="_blank">Watch Video Guide</a>

📱 Splash Screen
Displays the app logo on launch.
Automatically navigates to the welcome page after a few seconds.

👋 Welcome Page
Displays a full-screen background image.
Includes two buttons:
Sign In: Navigate to login page , Sign Up: Navigate to register page.

🔐 Login Page
Users can log in using email and password.
Includes input validation and error handling.
Integrated with Firebase Authentication.

📝 Register Page
Allows new users to create an account by providing:
Name
Email
Password
Includes form validation.

🏠 Home Page
Displays all products using a Grid View layout.
Each product card includes:
Product image
Name
Price
Favorite icon

📄 Product Details Page
Shows detailed information about the selected product:
Large product image
Product name and price
Product description
"Add to Cart" button

🛒 Cart Page
Displays all products added to the cart.
Features include:
Quantity update
Remove item from cart
Total price calculation

❤️ Favorite Page
Displays favorite products as cards.
Allows removing products from favorites.

👤 Profile Page
Displays user's profile data:
Image
Name
Allows users to edit their information.
Includes a Logout button.

➕ Add Product Page
Used to add a new product with the following fields:
Product Name
Description
Image (upload from gallery or camera)
Category
Product is saved to backend (Firebase Firestore).

✅ Technologies Used
Flutter
Dart
Firebase Authentication
Firebase Firestore
Hive / SharedPreferences (for local storage)
Image Picker (to upload product images)
