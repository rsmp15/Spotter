import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../theme/spott_theme.dart';
import '../../widgets/premium/glassmorphism.dart';


class PremiumMarketplaceScreen extends StatelessWidget {
  const PremiumMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpottTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Marketplace", style: SpottTheme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategories(),
          const SizedBox(height: SpottTheme.spacingMedium),
          Expanded(
            child: _buildProductGrid(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: SpottTheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("Sell Item", style: SpottTheme.textTheme.labelLarge?.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(SpottTheme.spacingLarge),
      child: Glassmorphism(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        borderRadius: 24,
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search products, services...",
            hintStyle: TextStyle(color: SpottTheme.textSecondary),
            icon: const Icon(Icons.search, color: SpottTheme.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ["All", "Electronics", "Vehicles", "Properties", "Services", "Travel Gear"];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: SpottTheme.spacingLarge),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: SpottTheme.spacingSmall),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? SpottTheme.primary : SpottTheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              categories[index],
              style: SpottTheme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : SpottTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return MasonryGridView.count(
      padding: const EdgeInsets.all(SpottTheme.spacingLarge),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: 8,
      itemBuilder: (context, index) {
        return _buildProductCard(index);
      },
    );
  }

  Widget _buildProductCard(int index) {
    return Glassmorphism(
      borderRadius: SpottTheme.radiusMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: index % 2 == 0 ? 150 : 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(SpottTheme.radiusMedium)),
              image: DecorationImage(
                image: NetworkImage('https://picsum.photos/seed/product$index/400/400'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product Name $index",
                  style: SpottTheme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "₹ ${(index + 1) * 1500}",
                  style: SpottTheme.textTheme.labelLarge?.copyWith(color: SpottTheme.primary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: SpottTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text("Pune, MH", style: SpottTheme.textTheme.labelMedium),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
