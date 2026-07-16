import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/emergency_contact.dart';
import '../../models/helpline.dart';
import '../../shared/providers.dart';

class ContactsView extends ConsumerStatefulWidget {
  const ContactsView({super.key});

  @override
  ConsumerState<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends ConsumerState<ContactsView> {
  int _activeSegment = 0; // 0 = Emergency Contacts, 1 = Official Helplines
  String _searchQuery = '';

  Future<void> _makeCall(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendSms(String number) async {
    final uri = Uri.parse('sms:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String number) async {
    final cleanNumber = number.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('https://wa.me/$cleanNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(contactsProvider);
    final helplinesAsync = ref.watch(helplinesProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom App Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.menu, color: AppColors.primaryRed),
                    SizedBox(width: 16),
                    Text(
                      'Contacts',
                      style: TextStyle(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.grey),
                      onPressed: () {},
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim().toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search contacts or helplines...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Segmented Tab Controls
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: context.colorScheme.onSurface.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _activeSegment = 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _activeSegment == 0 ? context.colorScheme.surface : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Emergency Contacts',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _activeSegment == 0 ? AppColors.primaryRed : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _activeSegment = 1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _activeSegment == 1 ? context.colorScheme.surface : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Official Helplines',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _activeSegment == 1 ? AppColors.primaryRed : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Main Listing
            Expanded(
              child: _activeSegment == 0
                  ? contactsAsync.when(
                      data: (contacts) {
                        final filtered = contacts.where((c) =>
                            c.name.toLowerCase().contains(_searchQuery) ||
                            c.relationship.toLowerCase().contains(_searchQuery)).toList();

                        if (filtered.isEmpty) {
                          return const Center(child: Text('No contacts found. Tap + to add.'));
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                              child: Text(
                                'Family & Physicians (Drag to set priority)',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                            ),
                            Expanded(
                              child: ReorderableListView.builder(
                                itemCount: filtered.length,
                                onReorder: (oldIdx, newIdx) {
                                  if (newIdx > oldIdx) newIdx--;
                                  final item = filtered.removeAt(oldIdx);
                                  filtered.insert(newIdx, item);
                                  ref.read(contactsProvider.notifier).reorderContacts(filtered);
                                },
                                itemBuilder: (context, idx) {
                                  final contact = filtered[idx];
                                  return _buildContactTile(contact, idx);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Center(child: Text('Error loading contacts')),
                    )
                  : helplinesAsync.when(
                      data: (helplines) {
                        final filtered = helplines.where((h) =>
                            h.name.toLowerCase().contains(_searchQuery) ||
                            h.category.toLowerCase().contains(_searchQuery)).toList();

                        if (filtered.isEmpty) {
                          return const Center(child: Text('No helplines found.'));
                        }

                        return ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, idx) {
                            final helpline = filtered[idx];
                            return _buildHelplineTile(helpline);
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Center(child: Text('Error loading helplines')),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _activeSegment == 0
          ? FloatingActionButton(
              onPressed: () => context.push('/contacts/add'),
              backgroundColor: AppColors.primaryRed,
              child: const Icon(Icons.person_add_alt_1, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildContactTile(EmergencyContact contact, int idx) {
    return Card(
      key: ValueKey(contact.id),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Priority Index badge
            CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.primaryRed.withOpacity(0.1),
              child: Text(
                '${idx + 1}',
                style: const TextStyle(color: AppColors.primaryRed, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: context.colorScheme.onSurface),
                  ),
                  Text(
                    '${contact.relationship} • ${contact.primaryPhone}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.phone_rounded, color: AppColors.cameraGreen, size: 20),
                  onPressed: () => _makeCall(contact.primaryPhone),
                ),
                IconButton(
                  icon: const Icon(Icons.sms_rounded, color: AppColors.locationBlue, size: 20),
                  onPressed: () => _sendSms(contact.primaryPhone),
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_rounded, color: AppColors.phoneOrange, size: 18),
                  onPressed: () => _openWhatsApp(contact.primaryPhone),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                  onPressed: () {
                    ref.read(contactsProvider.notifier).deleteContact(contact.id);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHelplineTile(Helpline helpline) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      title: Text(
        helpline.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: context.colorScheme.onBackground),
      ),
      subtitle: Text(
        '${helpline.category} • ${helpline.number}',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.phone_rounded, color: AppColors.cameraGreen, size: 22),
            onPressed: () => _makeCall(helpline.number),
          ),
          IconButton(
            icon: const Icon(Icons.sms_rounded, color: AppColors.locationBlue, size: 22),
            onPressed: () => _sendSms(helpline.number),
          ),
        ],
      ),
    );
  }
}
