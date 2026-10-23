import React, { useState, useEffect } from 'react';
import { 
  Package, 
  Plus, 
  Search, 
  Filter, 
  Edit, 
  Trash2, 
  Check, 
  X, 
  Eye, 
  AlertCircle 
} from 'lucide-react';
import { mockService } from '../services/mockData';
import { Product, ProductCategory } from '../types';

export const Products: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [filteredProducts, setFilteredProducts] = useState<Product[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('all');
  
  // Modals
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [editingProduct, setEditingProduct] = useState<Product | null>(null);

  // Form State
  const [formData, setFormData] = useState({
    id: '',
    name: '',
    category: 'purifier' as ProductCategory,
    shortDescription: '',
    detailedDescription: '',
    retailPrice: 0,
    wholesalePrice: 0,
    stockQuantity: 10,
    imageUrl: '',
    verifiedBenefit: '',
  });

  const loadProducts = () => {
    const list = mockService.getProducts();
    setProducts(list);
  };

  useEffect(() => {
    loadProducts();
  }, []);

  useEffect(() => {
    let result = [...products];

    if (selectedCategory !== 'all') {
      result = result.filter(p => p.category === selectedCategory);
    }

    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      result = result.filter(p => 
        p.name.toLowerCase().includes(q) || 
        p.id.toLowerCase().includes(q) ||
        p.category.toLowerCase().includes(q)
      );
    }

    setFilteredProducts(result);
  }, [products, searchQuery, selectedCategory]);

  const handleToggleActive = (id: string, currentStatus: boolean) => {
    mockService.updateProduct(id, { isActive: !currentStatus });
    loadProducts();
  };

  const handleQuickStockUpdate = (id: string, delta: number) => {
    const prod = products.find(p => p.id === id);
    if (!prod) return;
    const newStock = Math.max(0, prod.stockQuantity + delta);
    mockService.updateProduct(id, { stockQuantity: newStock });
    loadProducts();
  };

  const handleOpenAddModal = () => {
    const nextId = `AP-${formData.category.substring(0, 2).toUpperCase()}-${(100 + products.length + 1)}`;
    setFormData({
      id: nextId,
      name: '',
      category: 'purifier',
      shortDescription: '',
      detailedDescription: '',
      retailPrice: 15000,
      wholesalePrice: 11000,
      stockQuantity: 25,
      imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=800&q=80',
      verifiedBenefit: 'Retains essential alkaline minerals.',
    });
    setEditingProduct(null);
    setIsAddModalOpen(true);
  };

  const handleOpenEditModal = (product: Product) => {
    setEditingProduct(product);
    setFormData({
      id: product.id,
      name: product.name,
      category: product.category,
      shortDescription: product.shortDescription,
      detailedDescription: product.detailedDescription,
      retailPrice: product.retailPrice,
      wholesalePrice: product.wholesalePrice,
      stockQuantity: product.stockQuantity,
      imageUrl: product.imageUrl,
      verifiedBenefit: product.verifiedBenefit || '',
    });
    setIsAddModalOpen(true);
  };

  const handleSaveProduct = (e: React.FormEvent) => {
    e.preventDefault();
    if (editingProduct) {
      mockService.updateProduct(editingProduct.id, {
        name: formData.name,
        category: formData.category,
        shortDescription: formData.shortDescription,
        detailedDescription: formData.detailedDescription,
        retailPrice: Number(formData.retailPrice),
        wholesalePrice: Number(formData.wholesalePrice),
        stockQuantity: Number(formData.stockQuantity),
        imageUrl: formData.imageUrl,
        verifiedBenefit: formData.verifiedBenefit,
      });
    } else {
      mockService.createProduct({
        id: formData.id,
        name: formData.name,
        category: formData.category,
        shortDescription: formData.shortDescription,
        detailedDescription: formData.detailedDescription,
        retailPrice: Number(formData.retailPrice),
        wholesalePrice: Number(formData.wholesalePrice),
        stockQuantity: Number(formData.stockQuantity),
        imageUrl: formData.imageUrl,
        verifiedBenefit: formData.verifiedBenefit,
        isActive: true,
        isFeatured: false,
        rating: 4.8,
        specifications: { "Purification Capacity": "15 LPH" },
        postedCount: 0,
      });
    }
    setIsAddModalOpen(false);
    loadProducts();
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl font-bold font-['Outfit'] text-slate-800">Product Catalogue ({products.length})</h2>
          <p className="text-slate-500 text-xs mt-0.5">Manage water purifiers, dispensers, pumps, membranes & replacement filters</p>
        </div>
        <button
          onClick={handleOpenAddModal}
          className="inline-flex items-center gap-2 px-4 py-2 bg-sky-600 hover:bg-sky-500 text-white font-semibold text-xs rounded-xl shadow-sm transition-colors"
        >
          <Plus className="w-4 h-4" />
          Add New Product
        </button>
      </div>

      {/* Filter and Search Bar */}
      <div className="bg-white p-4 rounded-2xl border border-slate-200/80 shadow-sm flex flex-col md:flex-row gap-4 justify-between items-center">
        <div className="relative w-full md:w-80">
          <Search className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search by product name, SKU or category..."
            className="w-full pl-9 pr-4 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500 transition-colors"
          />
        </div>

        {/* Category Pills */}
        <div className="flex items-center gap-2 overflow-x-auto w-full md:w-auto pb-1 md:pb-0">
          {[
            { id: 'all', label: 'All Products (60)' },
            { id: 'purifier', label: 'Purifiers (15)' },
            { id: 'dispenser', label: 'Dispensers (10)' },
            { id: 'pump', label: 'Pumps (10)' },
            { id: 'filter', label: 'Filters (15)' },
            { id: 'spare_part', label: 'Spare Parts (10)' },
          ].map((cat) => (
            <button
              key={cat.id}
              onClick={() => setSelectedCategory(cat.id)}
              className={`px-3 py-1.5 rounded-xl text-xs font-semibold whitespace-nowrap transition-colors ${
                selectedCategory === cat.id
                  ? 'bg-slate-900 text-white'
                  : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
              }`}
            >
              {cat.label}
            </button>
          ))}
        </div>
      </div>

      {/* Products Table */}
      <div className="bg-white rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="bg-slate-50/80 border-b border-slate-200 text-slate-500 uppercase font-semibold">
                <th className="py-3 px-4">Item & SKU</th>
                <th className="py-3 px-4">Category</th>
                <th className="py-3 px-4">Retail Price</th>
                <th className="py-3 px-4">Wholesale Price</th>
                <th className="py-3 px-4">Stock Level</th>
                <th className="py-3 px-4">Status</th>
                <th className="py-3 px-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredProducts.map((p) => {
                const isLowStock = p.stockQuantity <= 10;
                return (
                  <tr key={p.id} className="hover:bg-slate-50/50">
                    <td className="py-3 px-4">
                      <div className="flex items-center gap-3">
                        <img 
                          src={p.imageUrl} 
                          alt={p.name} 
                          className="w-10 h-10 rounded-lg object-cover border border-slate-200 bg-slate-50"
                        />
                        <div>
                          <div className="font-bold text-slate-800 line-clamp-1 max-w-xs">{p.name}</div>
                          <div className="text-[11px] font-mono text-slate-400">{p.id}</div>
                        </div>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <span className="px-2 py-0.5 bg-slate-100 text-slate-700 font-semibold rounded capitalize">
                        {p.category.replace('_', ' ')}
                      </span>
                    </td>
                    <td className="py-3 px-4 font-bold text-slate-800">
                      ₹{p.retailPrice.toLocaleString('en-IN')}
                    </td>
                    <td className="py-3 px-4 font-semibold text-sky-700">
                      ₹{p.wholesalePrice.toLocaleString('en-IN')}
                    </td>
                    <td className="py-3 px-4">
                      <div className="flex items-center gap-2">
                        <span className={`font-bold ${isLowStock ? 'text-amber-600' : 'text-slate-800'}`}>
                          {p.stockQuantity} units
                        </span>
                        <div className="flex items-center gap-1">
                          <button
                            onClick={() => handleQuickStockUpdate(p.id, -5)}
                            className="w-5 h-5 bg-slate-100 hover:bg-slate-200 rounded flex items-center justify-center font-bold text-slate-600"
                            title="Deduct 5"
                          >
                            -
                          </button>
                          <button
                            onClick={() => handleQuickStockUpdate(p.id, 5)}
                            className="w-5 h-5 bg-slate-100 hover:bg-slate-200 rounded flex items-center justify-center font-bold text-slate-600"
                            title="Add 5"
                          >
                            +
                          </button>
                        </div>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <button
                        onClick={() => handleToggleActive(p.id, p.isActive)}
                        className={`inline-flex items-center gap-1 px-2 py-0.5 rounded text-[11px] font-semibold transition-colors ${
                          p.isActive
                            ? 'bg-emerald-50 text-emerald-700 border border-emerald-200 hover:bg-emerald-100'
                            : 'bg-slate-100 text-slate-500 border border-slate-200 hover:bg-slate-200'
                        }`}
                      >
                        {p.isActive ? 'Active' : 'Deactivated'}
                      </button>
                    </td>
                    <td className="py-3 px-4 text-right">
                      <button
                        onClick={() => handleOpenEditModal(p)}
                        className="p-1.5 text-slate-600 hover:text-sky-600 hover:bg-sky-50 rounded-lg transition-colors"
                        title="Edit Product"
                      >
                        <Edit className="w-4 h-4" />
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add / Edit Modal */}
      {isAddModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm overflow-y-auto">
          <div className="bg-white rounded-2xl max-w-lg w-full p-6 shadow-xl border border-slate-100 my-8">
            <div className="flex items-center justify-between pb-4 border-b border-slate-100">
              <h3 className="font-bold text-base text-slate-800 font-['Outfit']">
                {editingProduct ? 'Edit Product Details' : 'Add New Water System'}
              </h3>
              <button 
                onClick={() => setIsAddModalOpen(false)}
                className="text-slate-400 hover:text-slate-600"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSaveProduct} className="space-y-4 mt-4 text-xs">
              <div>
                <label className="block font-semibold text-slate-700 mb-1">Product SKU / ID</label>
                <input
                  type="text"
                  required
                  disabled={Boolean(editingProduct)}
                  value={formData.id}
                  onChange={(e) => setFormData({ ...formData, id: e.target.value })}
                  className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl font-mono text-xs focus:outline-none focus:border-sky-500"
                />
              </div>

              <div>
                <label className="block font-semibold text-slate-700 mb-1">Product Name</label>
                <input
                  type="text"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-semibold text-slate-700 mb-1">Category</label>
                  <select
                    value={formData.category}
                    onChange={(e) => setFormData({ ...formData, category: e.target.value as ProductCategory })}
                    className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500"
                  >
                    <option value="purifier">Purifiers</option>
                    <option value="dispenser">Dispensers</option>
                    <option value="pump">Booster Pumps</option>
                    <option value="filter">Filters & Cartridges</option>
                    <option value="spare_part">Spare Parts</option>
                  </select>
                </div>
                <div>
                  <label className="block font-semibold text-slate-700 mb-1">Stock Quantity</label>
                  <input
                    type="number"
                    required
                    min={0}
                    value={formData.stockQuantity}
                    onChange={(e) => setFormData({ ...formData, stockQuantity: Number(e.target.value) })}
                    className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block font-semibold text-slate-700 mb-1">Retail Price (₹)</label>
                  <input
                    type="number"
                    required
                    min={1}
                    value={formData.retailPrice}
                    onChange={(e) => setFormData({ ...formData, retailPrice: Number(e.target.value) })}
                    className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500"
                  />
                </div>
                <div>
                  <label className="block font-semibold text-slate-700 mb-1">Wholesale Price (₹)</label>
                  <input
                    type="number"
                    required
                    min={1}
                    value={formData.wholesalePrice}
                    onChange={(e) => setFormData({ ...formData, wholesalePrice: Number(e.target.value) })}
                    className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500"
                  />
                </div>
              </div>

              <div>
                <label className="block font-semibold text-slate-700 mb-1">Image URL</label>
                <input
                  type="url"
                  required
                  value={formData.imageUrl}
                  onChange={(e) => setFormData({ ...formData, imageUrl: e.target.value })}
                  className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500"
                />
              </div>

              <div>
                <label className="block font-semibold text-slate-700 mb-1">Short Description</label>
                <textarea
                  rows={2}
                  required
                  value={formData.shortDescription}
                  onChange={(e) => setFormData({ ...formData, shortDescription: e.target.value })}
                  className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500"
                />
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setIsAddModalOpen(false)}
                  className="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-xl font-semibold"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-sky-600 hover:bg-sky-500 text-white rounded-xl font-bold shadow-sm"
                >
                  {editingProduct ? 'Update Product' : 'Create Product'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
