const { test, expect } = require('@playwright/test');

test.describe('Facultyware E2E Comprehensive Test Suite', () => {

  test.beforeEach(async ({ page }) => {
    // Pastikan session bersih dengan memanggil logout terlebih dahulu
    await page.goto('http://localhost:3000/logout');
    
    // Tunggu sampai selector input username siap sebelum mengisi
    await page.waitForSelector('input[name="username"]', { state: 'visible' });
    
    // Jalankan login
    await page.fill('input[name="username"]', 'admin');
    await page.fill('input[name="password"]', 'admin123');
    await page.click('button[type="submit"]');
    
    // Pastikan diarahkan ke dashboard/list page dengan timeout longgar (10 detik)
    await expect(page).toHaveURL(/.*potential-partners/, { timeout: 10000 });
  });

  // ============================================================
  // FITUR AGHA (POTENTIAL PARTNER)
  // ============================================================

  test('1. Tambah Data Potential Partner Baru', async ({ page }) => {
    // Navigasi ke halaman tambah
    await page.goto('http://localhost:3000/potential-partners/add');
    
    // Isi form
    const uniqueName = `Test Company ${Date.now()}`;
    await page.fill('input[name="company_name"]', uniqueName);
    await page.fill('input[name="contact_person"]', 'Ahmad Dani');
    await page.fill('input[name="email"]', 'dani@testcompany.com');
    await page.fill('input[name="phone"]', '+628123456789');
    await page.selectOption('select[name="partnership_type"]', 'Industry');
    await page.fill('textarea[name="address"]', 'Jl. Sudirman No. 45 Jakarta');
    await page.fill('textarea[name="description"]', 'Kemitraan magang industri');
    
    // Submit form
    await page.click('button[type="submit"]');
    
    // Verifikasi kembali ke list dan data baru ada di list
    await expect(page).toHaveURL(/.*potential-partners/);
    await expect(page.locator('tbody')).toContainText(uniqueName);
  });

  test('2. Lihat, Cari, dan Filter Data Potential Partner', async ({ page }) => {
    // Cari data berdasarkan kata kunci
    await page.fill('input[name="search"]', 'Test Company');
    await page.press('input[name="search"]', 'Enter');
    
    // Verifikasi data pencarian tampil
    await expect(page.locator('tbody')).toContainText('Test Company');
  });

  test('3. Edit Data Potential Partner', async ({ page }) => {
    // Klik tombol edit pertama di tabel berdasarkan title attribute (icon button)
    await page.click('table tbody tr:first-child a[title="Edit data"]');
    
    // Verifikasi halaman edit dimuat
    await expect(page).toHaveURL(/.*edit.*/);
    
    // Ubah data kontak person
    const updatedContact = `Updated Contact ${Date.now()}`;
    await page.fill('input[name="contact_person"]', updatedContact);
    
    // Simpan
    await page.click('button[type="submit"]');
    
    // Verifikasi kembali ke list dan data kontak terupdate
    await expect(page).toHaveURL(/.*potential-partners/);
    await expect(page.locator('tbody')).toContainText(updatedContact);
  });

  test('4. REST API Potential Partner (Agha)', async ({ page }) => {
    // Akses endpoint REST API
    await page.goto('http://localhost:3000/potential-partners/api');
    
    // Verifikasi response berupa JSON dan berisi status sukses
    const content = await page.textContent('body');
    const json = JSON.parse(content);
    expect(json.success).toBe(true);
    expect(Array.isArray(json.data)).toBe(true);
  });

  test('5. Ekspor Data Laporan (Excel & PDF - Agha)', async ({ page }) => {
    // Menggunakan page.evaluate untuk mengklik link download yang berada di dalam menu dropdown
    const [downloadExcel] = await Promise.all([
      page.waitForEvent('download'),
      page.evaluate(() => {
        const link = document.querySelector('a[href="/potential-partners/export/excel"]');
        if (link) link.click();
      })
    ]);
    expect(downloadExcel.suggestedFilename()).toContain('.xlsx');

    const [downloadPdf] = await Promise.all([
      page.waitForEvent('download'),
      page.evaluate(() => {
        const link = document.querySelector('a[href="/potential-partners/export/pdf"]');
        if (link) link.click();
      })
    ]);
    expect(downloadPdf.suggestedFilename()).toContain('.pdf');
  });

  // ============================================================
  // FITUR HUBBIL (MoU, FOLLOW-UP, API, & EXPORT)
  // ============================================================

  test('6. Kelola MoU & Follow Up Kerjasama (Hubbil)', async ({ page }) => {
    // --- TAMBAH RIWAYAT FOLLOW-UP ---
    await page.goto('http://localhost:3000/follow-up/create');
    await page.selectOption('select[name="potential_partner_id"]', { index: 1 });
    await page.fill('textarea[name="catatan"]', 'Follow up diskusi draft MoU');
    await page.fill('input[name="tanggal"]', '2026-06-25');
    await page.click('button[type="submit"]');
    await expect(page).toHaveURL(/.*follow-up/);

    // --- BUAT DRAFT MoU BARU ---
    await page.goto('http://localhost:3000/mou/create');
    await page.selectOption('select[name="potential_partner_id"]', { index: 1 });
    await page.fill('textarea[name="draft_isi"]', 'Ini adalah draf dokumen MoU kerjasama magang mahasiswa');
    await page.click('button[type="submit"]');
    await expect(page).toHaveURL(/.*mou/);
    
    // Verifikasi draft MoU berhasil masuk daftar list
    await expect(page.locator('tbody')).toContainText('draft');
  });

  test('7. REST API & Ekspor MoU (Hubbil)', async ({ page }) => {
    // Akses endpoint REST API MoU milik Hubbil
    await page.goto('http://localhost:3000/api/mou');
    const contentApi = await page.textContent('body');
    const jsonApi = JSON.parse(contentApi);
    expect(jsonApi.success).toBe(true);
    expect(Array.isArray(jsonApi.data)).toBe(true);

    // Buka halaman laporan MoU milik Hubbil (berupa render halaman print HTML)
    await page.goto('http://localhost:3000/export/mou');
    await expect(page.locator('body')).toContainText('Laporan', { ignoreCase: true });
  });

});
