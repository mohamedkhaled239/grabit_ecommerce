import 'package:flutter/material.dart';
import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/wishlist/controller/wishlist_cubit.dart';
import 'package:grabit_ecommerce/features/wishlist/model/wishlist_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grabit_ecommerce/features/cart/controller/cart_cubit.dart';
import 'package:grabit_ecommerce/features/cart/controller/cart_state.dart';
import 'package:grabit_ecommerce/features/cart/model/cart_item_model.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late String mainImageUrl;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    mainImageUrl = widget.product.mainImage;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            product.title.en,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.appBarTheme.iconTheme?.color,
          elevation: theme.appBarTheme.elevation ?? 1,
          bottom: TabBar(
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
            indicatorColor: theme.colorScheme.primary,
            tabs: const [
              Tab(text: 'Detail'),
              Tab(text: 'Specifications'),
              Tab(text: 'Vendor'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Product Image and Info Row
            Container(
              color: theme.colorScheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Image and images row
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          mainImageUrl,
                          height: 140,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (product.images.isNotEmpty)
                        SizedBox(
                          height: 55,
                          width: 140,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: product.images.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final imgUrl = product.images[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    mainImageUrl = imgUrl;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: mainImageUrl == imgUrl 
                                          ? theme.colorScheme.primary 
                                          : theme.colorScheme.onSurface.withOpacity(0.2),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imgUrl,
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Quantity Control and Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Quantity Control
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colorScheme.onSurface.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 16),
                                  padding: const EdgeInsets.all(4),
                                  constraints: const BoxConstraints(),
                                  color: quantity > 1 
                                      ? theme.colorScheme.primary 
                                      : theme.colorScheme.onSurface.withOpacity(0.3),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    quantity.toString(),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 16),
                                  padding: const EdgeInsets.all(4),
                                  constraints: const BoxConstraints(),
                                  color: quantity < 10 
                                      ? theme.colorScheme.primary 
                                      : theme.colorScheme.onSurface.withOpacity(0.3),
                                  onPressed: () {
                                    if (quantity < 10) {
                                      setState(() {
                                        quantity++;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Maximum quantity is 10',
                                            style: TextStyle(
                                              color: theme.colorScheme.onPrimary,
                                            ),
                                          ),
                                          backgroundColor: theme.colorScheme.error,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Add to Cart Button
                          BlocBuilder<CartCubit, CartState>(
                            builder: (context, state) {
                              final isInCart = state is CartLoaded && 
                                  state.items.any((item) => item.productId == product.productId);
                              return IconButton(
                                onPressed: () {
                                  final cartCubit = context.read<CartCubit>();
                                  if (isInCart) {
                                    final cartItem = state.items.firstWhere(
                                      (item) => item.productId == product.productId
                                    );
                                    cartCubit.removeFromCart(cartItem.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Product removed from cart',
                                          style: TextStyle(
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                        backgroundColor: theme.colorScheme.error,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  } else {
                                    cartCubit.addToCart(
                                      CartItem(
                                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                                        productId: product.productId,
                                        name: product.title.en,
                                        imageUrl: product.mainImage,
                                        price: product.price,
                                        quantity: quantity,
                                        categoryName: product.categoryName,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Product added to cart',
                                          style: TextStyle(
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                        backgroundColor: theme.colorScheme.primary,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                                  size: 20,
                                  color: isInCart 
                                      ? theme.colorScheme.primary 
                                      : theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(),
                              );
                            },
                          ),
                          // Wishlist Button
                          BlocBuilder<WishlistCubit, WishlistState>(
                            builder: (context, state) {
                              final isInWishlist = state is WishlistLoaded && 
                                  state.items.any((item) => item.id == product.productId);
                              return IconButton(
                                icon: Icon(
                                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                                  color: isInWishlist 
                                      ? theme.colorScheme.error 
                                      : theme.colorScheme.onSurface.withOpacity(0.6),
                                  size: 20,
                                ),
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  final wishlistCubit = context.read<WishlistCubit>();
                                  if (isInWishlist) {
                                    wishlistCubit.removeFromWishlist(product.productId);
                                  } else {
                                    wishlistCubit.addToWishlist(
                                      WishlistItem(
                                        id: product.productId,
                                        name: product.title.en,
                                        imageUrl: product.mainImage,
                                        price: product.price,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  // Product Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title.en,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "${product.price} EGP",
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "SKU#: ${product.productId}",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.categoryName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Tabs
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: TabBarView(
                  children: [
                    // Detail Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: product.description.en.isNotEmpty
                          ? Text(
                              htmlToPlainText(product.description.en),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                              ),
                              textAlign: TextAlign.justify,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            )
                          : Text(
                              "No description available.",
                              style: theme.textTheme.bodyMedium,
                            ),
                    ),
                    // Specifications Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.category,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Category: ",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                product.categoryName,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.confirmation_number,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "SKU: ",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                product.productId,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Vendor Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.store,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Vendor ID: ${product.vendorId}",
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    // Reviews Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        "No reviews yet. ${product.views}",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String htmlToPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }
} 