.class public Lcom/auth/LoginActivity;
.super Landroid/app/Activity;
.source "LoginActivity.java"

# Mengimplementasikan ClickListener dan Runnable di satu file
.implements Landroid/view/View$OnClickListener;
.implements Ljava/lang/Runnable;

# Fields untuk komponen UI
.field private btnLogin:Landroid/widget/Button;
.field private edtKey:Landroid/widget/EditText;

# Field temporary untuk menampung Key saat proses background thread
.field private tempKey:Ljava/lang/String;

.method public constructor <init>()V
    .registers 1
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .registers 8

    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    # 1. Membuat Layout Utama (LinearLayout) secara programmatic
    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V
    
    # Padding layout
    const/16 v2, 0x32
    invoke-virtual {v0, v2, v2, v2, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # 2. Input Kolom Key (Hanya 1 Kolom)
    new-instance v2, Landroid/widget/EditText;
    invoke-direct {v2, p0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V
    iput-object v2, p0, Lcom/auth/LoginActivity;->edtKey:Landroid/widget/EditText;
    iget-object v2, p0, Lcom/auth/LoginActivity;->edtKey:Landroid/widget/EditText;
    const-string v3, "Masukkan Key / Lisensi Anda"
    invoke-virtual {v2, v3}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V
    
    # Set input type text biasa
    iget-object v2, p0, Lcom/auth/LoginActivity;->edtKey:Landroid/widget/EditText;
    const/4 v3, 0x1
    invoke-virtual {v2, v3}, Landroid/widget/EditText;->setInputType(I)V
    iget-object v2, p0, Lcom/auth/LoginActivity;->edtKey:Landroid/widget/EditText;
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # 3. Tombol Login
    new-instance v2, Landroid/widget/Button;
    invoke-direct {v2, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    iput-object v2, p0, Lcom/auth/LoginActivity;->btnLogin:Landroid/widget/Button;
    iget-object v2, p0, Lcom/auth/LoginActivity;->btnLogin:Landroid/widget/Button;
    const-string v3, "AKTIVASI KEY"
    invoke-virtual {v2, v3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    
    # Set onClickListener langsung merujuk ke kelas ini (p0)
    iget-object v2, p0, Lcom/auth/LoginActivity;->btnLogin:Landroid/widget/Button;
    invoke-virtual {v2, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    iget-object v2, p0, Lcom/auth/LoginActivity;->btnLogin:Landroid/widget/Button;
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Set contentView ke layout dinamis
    invoke-virtual {p0, v0}, Landroid/view/View;->setContentView(Landroid/view/View;)V

    # ========================================================
    # AUTO-SAVE & AUTO-LOGIN READ (STARTUP)
    # ========================================================
    const-string v2, "KeyPrefs"
    const/4 v3, 0x0
    invoke-virtual {p0, v2, v3}, Lcom/auth/LoginActivity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2

    const-string v3, "saved_key"
    const-string v4, ""
    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z
    move-result v3
    if-nez v3, :cond_c7

    # Isi form otomatis dengan key yang tersimpan
    iget-object v3, p0, Lcom/auth/LoginActivity;->edtKey:Landroid/widget/EditText;
    invoke-virtual {v3, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    # Jalankan Auto-Login / Validasi otomatis ke GitHub
    invoke-direct {p0, v2}, Lcom/auth/LoginActivity;->checkKeyOnline(Ljava/lang/String;)V

    :cond_c7
    return-void
.end method

# Handler saat tombol klik aktif
.method public onClick(Landroid/view/View;)V
    .registers 3

    iget-object v0, p0, Lcom/auth/LoginActivity;->edtKey:Landroid/widget/EditText;
    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;
    move-result-object v0

    invoke-direct {p0, v0}, Lcom/auth/LoginActivity;->checkKeyOnline(Ljava/lang/String;)V

    return-void
.end method

# Mengatur background thread
.method private checkKeyOnline(Ljava/lang/String;)V
    .registers 3

    # Simpan teks key ke variabel temporary sebelum pindah thread
    iput-object p1, p0, Lcom/auth/LoginActivity;->tempKey:Ljava/lang/String;

    new-instance v0, Ljava/lang/Thread;
    invoke-direct {v0, p0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

# Background thread proses HTTP Request ke GitHub
.method public run()V
    .registers 6

    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :try_start_0
    # GANTI DENGAN URL GITHUB RAW DAFTAR KEY ANDA
    const-string v0, "https://githubusercontent.com"
    
    new-instance v1, Ljava/net/URL;
    invoke-direct {v1, v0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v1}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v1
    check-cast v1, Ljava/net/HttpURLConnection;
    
    const-string v0, "GET"
    invoke-virtual {v1, v0}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    new-instance v0, Ljava/io/BufferedReader;
    new-instance v2, Ljava/io/InputStreamReader;
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v1
    invoke-direct {v2, v1}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V
    invoke-direct {v0, v2}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    # Ambil key input dari user
    iget-object v1, p0, Lcom/auth/LoginActivity;->tempKey:Ljava/lang/String;

    :cond_0
    invoke-virtual {v0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v2
    if-eqz v2, :cond_1

    # Cek apakah baris di file GitHub sama persis dengan key input
    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :cond_0

    # BERHASIL AKTIVASI KEY
    invoke-direct {p0}, Lcom/auth/LoginActivity;->onLoginSuccess()V
    return-void

    :cond_1
    # KEY TIDAK DITEMUKAN
    invoke-direct {p0}, Lcom/auth/LoginActivity;->onLoginFailed()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0
    # KONEKSI EROR / OFFLINE
    invoke-direct {p0}, Lcom/auth/LoginActivity;->onLoginFailed()V

    :goto_0
    return-void
.end method

# Method internal untuk memproses kesuksesan (Save Key ke SharedPreferences)
.method private onLoginSuccess()V
    .registers 4

    # Simpan Key secara permanen
    const-string v0, "KeyPrefs"
    const/4 v1, 0x0
    invoke-virtual {p0, v0, v1}, Lcom/auth/LoginActivity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    
    const-string v1, "saved_key"
    iget-object v2, p0, Lcom/auth/LoginActivity;->tempKey:Ljava/lang/String;
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    # Tampilkan pesan sukses
    const-string v0, "Aktivasi Berhasil!"
    const/4 v1, 0x0
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    # Tutup login screen
    invoke-virtual {p0}, Lcom/auth/LoginActivity;->finish()V
    return-void
.end method

# Method internal untuk memproses kegagalan
.method private onLoginFailed()V
    .registers 3

    const-string v0, "Key Tidak Valid / Periksa Koneksi Internet!"
    const/4 v1, 0x0
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v0
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    return-void
.end method
