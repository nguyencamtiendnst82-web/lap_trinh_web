
-- =====================================================
-- 1. TAO CO SO DU LIEU
-- =====================================================
CREATE DATABASE IF NOT EXISTS he_thong_hoc_tap_ai
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE he_thong_hoc_tap_ai;

-- =====================================================
-- 2. TAI KHOAN VA PHAN QUYEN
-- =====================================================

CREATE TABLE vai_tro (
    ma_vai_tro INT AUTO_INCREMENT PRIMARY KEY,
    ten_vai_tro VARCHAR(50) NOT NULL UNIQUE,
    mo_ta TEXT
) ENGINE=InnoDB;

CREATE TABLE nguoi_dung (
    ma_nguoi_dung INT AUTO_INCREMENT PRIMARY KEY,
    ho_ten VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    ten_dang_nhap VARCHAR(50) NOT NULL UNIQUE,
    mat_khau VARCHAR(255) NOT NULL,
    trang_thai TINYINT(1) DEFAULT 1,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    ngay_cap_nhat DATETIME DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE nguoi_dung_vai_tro (
    ma_nguoi_dung INT NOT NULL,
    ma_vai_tro INT NOT NULL,
    ngay_cap DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ma_nguoi_dung, ma_vai_tro),
    FOREIGN KEY (ma_nguoi_dung)
        REFERENCES nguoi_dung(ma_nguoi_dung),
    FOREIGN KEY (ma_vai_tro)
        REFERENCES vai_tro(ma_vai_tro)
) ENGINE=InnoDB;

CREATE TABLE phien_dang_nhap (
    ma_phien INT AUTO_INCREMENT PRIMARY KEY,
    ma_nguoi_dung INT NOT NULL,
    token_hash VARCHAR(255) NOT NULL UNIQUE,
    thoi_han DATETIME NOT NULL,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ma_nguoi_dung)
        REFERENCES nguoi_dung(ma_nguoi_dung)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 3. KHOA HOC VA NOI DUNG HOC TAP
-- =====================================================

CREATE TABLE khoa_hoc (
    ma_khoa_hoc INT AUTO_INCREMENT PRIMARY KEY,
    ten_khoa_hoc VARCHAR(100) NOT NULL,
    mo_ta TEXT,
    do_kho ENUM('De', 'Trung binh', 'Kho')
        DEFAULT 'Trung binh',
    ma_chuyen_gia INT,
    trang_thai ENUM('Cho duyet', 'Dang mo', 'Da dong')
        DEFAULT 'Cho duyet',
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    ngay_cap_nhat DATETIME DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ma_chuyen_gia)
        REFERENCES nguoi_dung(ma_nguoi_dung)
        ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE bai_hoc (
    ma_bai_hoc INT AUTO_INCREMENT PRIMARY KEY,
    ma_khoa_hoc INT NOT NULL,
    tieu_de VARCHAR(100) NOT NULL,
    noi_dung TEXT,
    vi_du_mau TEXT,
    vi_tri INT DEFAULT 1,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ma_khoa_hoc)
        REFERENCES khoa_hoc(ma_khoa_hoc)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE dang_ky_khoa_hoc (
    ma_dang_ky INT AUTO_INCREMENT PRIMARY KEY,
    ma_nguoi_dung INT NOT NULL,
    ma_khoa_hoc INT NOT NULL,
    ngay_dang_ky DATETIME DEFAULT CURRENT_TIMESTAMP,
    trang_thai ENUM('Dang hoc', 'Hoan thanh', 'Huy')
        DEFAULT 'Dang hoc',
    UNIQUE (ma_nguoi_dung, ma_khoa_hoc),
    FOREIGN KEY (ma_nguoi_dung)
        REFERENCES nguoi_dung(ma_nguoi_dung),
    FOREIGN KEY (ma_khoa_hoc)
        REFERENCES khoa_hoc(ma_khoa_hoc)
) ENGINE=InnoDB;

CREATE TABLE tien_do_hoc_tap (
    ma_tien_do INT AUTO_INCREMENT PRIMARY KEY,
    ma_nguoi_dung INT NOT NULL,
    ma_bai_hoc INT NOT NULL,
    hoan_thanh TINYINT(1) DEFAULT 0,
    ngay_hoan_thanh DATETIME,
    UNIQUE (ma_nguoi_dung, ma_bai_hoc),
    FOREIGN KEY (ma_nguoi_dung)
        REFERENCES nguoi_dung(ma_nguoi_dung),
    FOREIGN KEY (ma_bai_hoc)
        REFERENCES bai_hoc(ma_bai_hoc)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 4. BAI TAP, KIEM THU VA CHAM BAI
-- =====================================================

CREATE TABLE bai_tap (
    ma_bai_tap INT AUTO_INCREMENT PRIMARY KEY,
    ma_bai_hoc INT NOT NULL,
    tieu_de VARCHAR(100) NOT NULL,
    mo_ta TEXT,
    do_kho ENUM('De', 'Trung binh', 'Kho')
        DEFAULT 'Trung binh',
    ngon_ngu VARCHAR(50) DEFAULT 'C++',
    ma_chuyen_gia INT,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ma_bai_hoc)
        REFERENCES bai_hoc(ma_bai_hoc)
        ON DELETE CASCADE,
    FOREIGN KEY (ma_chuyen_gia)
        REFERENCES nguoi_dung(ma_nguoi_dung)
        ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE ca_kiem_thu (
    ma_ca_kiem_thu INT AUTO_INCREMENT PRIMARY KEY,
    ma_bai_tap INT NOT NULL,
    du_lieu_dau_vao TEXT,
    ket_qua_mong_doi TEXT,
    la_mau TINYINT(1) DEFAULT 0,
    FOREIGN KEY (ma_bai_tap)
        REFERENCES bai_tap(ma_bai_tap)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE bai_nop (
    ma_bai_nop INT AUTO_INCREMENT PRIMARY KEY,
    ma_nguoi_dung INT NOT NULL,
    ma_bai_tap INT NOT NULL,
    ma_nguon TEXT NOT NULL,
    ngon_ngu VARCHAR(50) DEFAULT 'C++',
    ngay_nop DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ma_nguoi_dung)
        REFERENCES nguoi_dung(ma_nguoi_dung),
    FOREIGN KEY (ma_bai_tap)
        REFERENCES bai_tap(ma_bai_tap)
) ENGINE=InnoDB;

CREATE TABLE ket_qua_cham (
    ma_ket_qua INT AUTO_INCREMENT PRIMARY KEY,
    ma_bai_nop INT NOT NULL,
    diem_so DECIMAL(5,2) DEFAULT 0,
    trang_thai ENUM('Dat', 'Khong dat', 'Loi')
        DEFAULT 'Loi',
    thoi_gian_chay INT,
    thong_bao_loi TEXT,
    ngay_cham DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ma_bai_nop)
        REFERENCES bai_nop(ma_bai_nop)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 5. TRAC NGHIEM
-- =====================================================

CREATE TABLE cau_hoi_trac_nghiem (
    ma_cau_hoi INT AUTO_INCREMENT PRIMARY KEY,
    ma_bai_hoc INT NOT NULL,
    noi_dung_cau_hoi TEXT NOT NULL,
    loai_cau_hoi ENUM('Trac nghiem', 'Tu luan')
        DEFAULT 'Trac nghiem',
    diem DECIMAL(5,2) DEFAULT 1,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ma_bai_hoc)
        REFERENCES bai_hoc(ma_bai_hoc)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE phuong_an (
    ma_phuong_an INT AUTO_INCREMENT PRIMARY KEY,
    ma_cau_hoi INT NOT NULL,
    noi_dung_phuong_an TEXT NOT NULL,
    la_dap_an_dung TINYINT(1) DEFAULT 0,
    FOREIGN KEY (ma_cau_hoi)
        REFERENCES cau_hoi_trac_nghiem(ma_cau_hoi)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE lan_lam_bai (
    ma_lan_lam INT AUTO_INCREMENT PRIMARY KEY,
    ma_nguoi_dung INT NOT NULL,
    ma_cau_hoi INT NOT NULL,
    ma_phuong_an_chon INT,
    dung TINYINT(1) DEFAULT 0,
    thoi_gian DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ma_nguoi_dung)
        REFERENCES nguoi_dung(ma_nguoi_dung),
    FOREIGN KEY (ma_cau_hoi)
        REFERENCES cau_hoi_trac_nghiem(ma_cau_hoi),
    FOREIGN KEY (ma_phuong_an_chon)
        REFERENCES phuong_an(ma_phuong_an)
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- =====================================================
-- 6. PHAN TICH DIEM YEU VA LO TRINH
-- =====================================================

CREATE TABLE chu_de (
    ma_chu_de INT AUTO_INCREMENT PRIMARY KEY,
    ten_chu_de VARCHAR(100) NOT NULL,
    mo_ta TEXT
) ENGINE=InnoDB;

CREATE TABLE bai_tap_chu_de (
    ma_bai_tap INT NOT NULL,
    ma_chu_de INT NOT NULL,
    PRIMARY KEY (ma_bai_tap, ma_chu_de),
    FOREIGN KEY (ma_bai_tap)
        REFERENCES bai_tap(ma_bai_tap)
        ON DELETE CASCADE,
    FOREIGN KEY (ma_chu_de)
        REFERENCES chu_de(ma_chu_de)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE diem_theo_chu_de (
    ma_diem INT AUTO_INCREMENT PRIMARY KEY,
    ma_nguoi_dung INT NOT NULL,
    ma_chu_de INT NOT NULL,
    diem_trung_binh DECIMAL(5,2) DEFAULT 0,
    ngay_cap_nhat DATETIME DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (ma_nguoi_dung, ma_chu_de),
    FOREIGN KEY (ma_nguoi_dung)
        REFERENCES nguoi_dung(ma_nguoi_dung),
    FOREIGN KEY (ma_chu_de)
        REFERENCES chu_de(ma_chu_de)
) ENGINE=InnoDB;

CREATE TABLE phan_tich_diem_yeu (
    ma_phan_tich INT AUTO_INCREMENT PRIMARY KEY,
    ma_nguoi_dung INT NOT NULL,
    ma_chu_de INT NOT NULL,
    muc_do_yeu ENUM('Thap', 'Trung binh', 'Cao')
        DEFAULT 'Trung binh',
    ngay_phan_tich DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ma_nguoi_dung)
        REFERENCES nguoi_dung(ma_nguoi_dung),
    FOREIGN KEY (ma_chu_de)
        REFERENCES chu_de(ma_chu_de)
) ENGINE=InnoDB;

CREATE TABLE de_xuat_lo_trinh (
    ma_de_xuat INT AUTO_INCREMENT PRIMARY KEY,
    ma_nguoi_dung INT NOT NULL,
    ma_chu_de INT NOT NULL,
    mo_ta TEXT,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    trang_thai ENUM('Chua hoc', 'Dang hoc', 'Da hoan thanh')
        DEFAULT 'Chua hoc',
    FOREIGN KEY (ma_nguoi_dung)
        REFERENCES nguoi_dung(ma_nguoi_dung),
    FOREIGN KEY (ma_chu_de)
        REFERENCES chu_de(ma_chu_de)
) ENGINE=InnoDB;

-- =====================================================
-- 7. CONG DONG VA QUAN TRI
-- =====================================================

CREATE TABLE chu_de_dien_dan (
    ma_chu_de_dien_dan INT AUTO_INCREMENT PRIMARY KEY,
    ma_nguoi_dung INT NOT NULL,
    tieu_de VARCHAR(200) NOT NULL,
    noi_dung TEXT NOT NULL,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    trang_thai ENUM('Hien thi', 'An')
        DEFAULT 'Hien thi',
    FOREIGN KEY (ma_nguoi_dung)
        REFERENCES nguoi_dung(ma_nguoi_dung)
) ENGINE=InnoDB;

CREATE TABLE bai_dang_dien_dan (
    ma_bai_dang INT AUTO_INCREMENT PRIMARY KEY,
    ma_chu_de_dien_dan INT NOT NULL,
    ma_nguoi_dung INT NOT NULL,
    noi_dung TEXT NOT NULL,
    parent_post_id INT NULL,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ma_chu_de_dien_dan)
        REFERENCES chu_de_dien_dan(ma_chu_de_dien_dan)
        ON DELETE CASCADE,
    FOREIGN KEY (ma_nguoi_dung)
        REFERENCES nguoi_dung(ma_nguoi_dung),
    FOREIGN KEY (parent_post_id)
        REFERENCES bai_dang_dien_dan(ma_bai_dang)
        ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE cau_hoi_thuong_gap (
    ma_cau_hoi INT AUTO_INCREMENT PRIMARY KEY,
    cau_hoi TEXT NOT NULL,
    tra_loi TEXT NOT NULL,
    ma_nguoi_tao INT,
    trang_thai ENUM('Hien thi', 'An')
        DEFAULT 'Hien thi',
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ma_nguoi_tao)
        REFERENCES nguoi_dung(ma_nguoi_dung)
        ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE nhat_ky_he_thong (
    ma_nhat_ky INT AUTO_INCREMENT PRIMARY KEY,
    ma_nguoi_dung INT,
    hanh_dong VARCHAR(100) NOT NULL,
    mo_ta TEXT,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ma_nguoi_dung)
        REFERENCES nguoi_dung(ma_nguoi_dung)
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- =====================================================
-- 8. DU LIEU VAI TRO BAN DAU
-- =====================================================

INSERT INTO vai_tro (ten_vai_tro, mo_ta) VALUES
('Hoc vien', 'Nguoi tham gia hoc tap'),
('Chuyen gia', 'Nguoi tao khoa hoc va bai tap'),
('Quan tri vien', 'Nguoi quan ly he thong');

-- =====================================================
-- 9. NAP DU LIEU TAI KHOAN VA PHAN QUYEN
-- =====================================================

INSERT INTO nguoi_dung
(ma_nguoi_dung, ho_ten, email, ten_dang_nhap, mat_khau)
VALUES
(1, 'Nguyen Van An', 'an@gmail.com', 'hocvien1', 'HASH_MAU_1'),
(2, 'Tran Thi Binh', 'binh@gmail.com', 'chuyengia1', 'HASH_MAU_2'),
(3, 'Le Van Cuong', 'cuong@gmail.com', 'admin1', 'HASH_MAU_3'),
(4, 'Pham Thi Dung', 'dung@gmail.com', 'hocvien2', 'HASH_MAU_4'),
(5, 'Hoang Van Em', 'em@gmail.com', 'hocvien3', 'HASH_MAU_5');

INSERT INTO nguoi_dung_vai_tro
(ma_nguoi_dung, ma_vai_tro)
VALUES
(1, 1), (2, 2), (3, 3), (4, 1), (5, 1);

INSERT INTO phien_dang_nhap
(ma_nguoi_dung, token_hash, thoi_han)
VALUES
(1, 'HASH_TOKEN_MAU_001', '2027-01-01 23:59:59'),
(2, 'HASH_TOKEN_MAU_002', '2027-01-01 23:59:59');

-- =====================================================
-- 10. KHOA HOC, BAI HOC VA TIEN DO
-- =====================================================

INSERT INTO khoa_hoc
(ten_khoa_hoc, mo_ta, do_kho, ma_chuyen_gia, trang_thai)
VALUES
('Lap trinh C++ co ban', 'Hoc bien, cau truc dieu khien va vong lap',
 'De', 2, 'Dang mo'),
('Thuat toan va cau truc du lieu', 'Hoc mang, tim kiem va sap xep',
 'Trung binh', 2, 'Dang mo');

INSERT INTO bai_hoc
(ma_khoa_hoc, tieu_de, noi_dung, vi_du_mau, vi_tri)
VALUES
(1, 'Bien va kieu du lieu', 'Tim hieu bien va kieu du lieu',
 'int a = 10;', 1),
(1, 'Cau truc re nhanh', 'Su dung if va else',
 'if (a > 0) cout << a;', 2),
(1, 'Vong lap', 'Hoc vong lap for va while',
 'for (int i = 1; i <= 5; i++) {}', 3),
(2, 'Tim kiem tuyen tinh', 'Tim phan tu trong mang',
 'Tim vi tri cua x', 1),
(2, 'Sap xep mang', 'Sap xep tang dan',
 'Sap xep cac phan tu', 2);

INSERT INTO dang_ky_khoa_hoc
(ma_nguoi_dung, ma_khoa_hoc, trang_thai)
VALUES
(1, 1, 'Dang hoc'),
(4, 1, 'Dang hoc'),
(5, 1, 'Hoan thanh'),
(1, 2, 'Dang hoc');

INSERT INTO tien_do_hoc_tap
(ma_nguoi_dung, ma_bai_hoc, hoan_thanh, ngay_hoan_thanh)
VALUES
(1, 1, 1, '2026-10-01 10:00:00'),
(1, 2, 1, '2026-10-02 10:00:00'),
(1, 3, 0, NULL),
(4, 1, 1, '2026-10-03 09:00:00'),
(5, 1, 1, '2026-10-04 08:00:00');

-- =====================================================
-- 11. BAI TAP, CA KIEM THU VA KET QUA CHAM
-- =====================================================

INSERT INTO bai_tap
(ma_bai_hoc, tieu_de, mo_ta, do_kho, ngon_ngu, ma_chuyen_gia)
VALUES
(1, 'Tinh tong hai so', 'Nhap hai so va in tong',
 'De', 'C++', 2),
(2, 'Kiem tra chan le', 'Kiem tra so nguyen chan hay le',
 'De', 'C++', 2),
(3, 'Tinh tong tu 1 den n', 'Tinh tong cac so tu 1 den n',
 'Trung binh', 'C++', 2),
(4, 'Tim phan tu trong mang', 'Tim vi tri cua x',
 'Trung binh', 'C++', 2);

INSERT INTO ca_kiem_thu
(ma_bai_tap, du_lieu_dau_vao, ket_qua_mong_doi, la_mau)
VALUES
(1, '2 3', '5', 1),
(1, '10 20', '30', 0),
(2, '4', 'Chan', 1),
(2, '7', 'Le', 1),
(3, '5', '15', 1),
(4, '5 1 3 5 7 5', '3', 1);

INSERT INTO bai_nop
(ma_nguoi_dung, ma_bai_tap, ma_nguon, ngon_ngu)
VALUES
(1, 1, '#include <iostream>\nusing namespace std;\nint main(){int a,b; cin>>a>>b; cout<<a+b;}', 'C++'),
(1, 2, '#include <iostream>\nusing namespace std;\nint main(){int n; cin>>n; if(n%2==0) cout<<"Chan"; else cout<<"Le";}', 'C++'),
(4, 1, '#include <iostream>\nusing namespace std;\nint main(){int a,b; cin>>a>>b; cout<<a+b;}', 'C++');

INSERT INTO ket_qua_cham
(ma_bai_nop, diem_so, trang_thai, thoi_gian_chay, thong_bao_loi)
VALUES
(1, 10.00, 'Dat', 15, NULL),
(2, 10.00, 'Dat', 12, NULL),
(3, 8.00, 'Dat', 18, NULL);

-- =====================================================
-- 12. CAU HOI TRAC NGHIEM VA PHUONG AN
-- =====================================================

INSERT INTO cau_hoi_trac_nghiem
(ma_bai_hoc, noi_dung_cau_hoi, loai_cau_hoi, diem)
VALUES
(1, 'Kieu du lieu nao luu so nguyen trong C++?',
 'Trac nghiem', 1),
(2, 'Toan tu nao dung de chia lay du?',
 'Trac nghiem', 1),
(3, 'Vong lap nao thuong dung khi biet so lan lap?',
 'Trac nghiem', 1);

INSERT INTO phuong_an
(ma_cau_hoi, noi_dung_phuong_an, la_dap_an_dung)
VALUES
(1, 'int', 1),
(1, 'string', 0),
(1, 'bool', 0),
(2, '%', 1),
(2, '/', 0),
(2, '+', 0),
(3, 'for', 1),
(3, 'switch', 0),
(3, 'break', 0);

INSERT INTO lan_lam_bai
(ma_nguoi_dung, ma_cau_hoi, ma_phuong_an_chon, dung)
VALUES
(1, 1, 1, 1),
(1, 2, 4, 1),
(1, 3, 8, 0),
(4, 1, 2, 0),
(4, 2, 4, 1);

-- =====================================================
-- 13. CHU DE VA PHAN TICH DIEM YEU
-- =====================================================

INSERT INTO chu_de (ten_chu_de, mo_ta)
VALUES
('Bien va kieu du lieu', 'Khai bao bien trong C++'),
('Cau truc re nhanh', 'Su dung if else va switch'),
('Vong lap', 'Su dung for, while va do while'),
('Mang', 'Xu ly mang mot chieu');

INSERT INTO bai_tap_chu_de (ma_bai_tap, ma_chu_de)
VALUES
(1, 1), (2, 2), (3, 3), (4, 4);

INSERT INTO diem_theo_chu_de
(ma_nguoi_dung, ma_chu_de, diem_trung_binh)
VALUES
(1, 1, 9.50),
(1, 2, 9.00),
(1, 3, 5.00),
(1, 4, 6.00),
(4, 1, 6.00),
(4, 2, 5.00);

INSERT INTO phan_tich_diem_yeu
(ma_nguoi_dung, ma_chu_de, muc_do_yeu)
VALUES
(1, 3, 'Cao'),
(1, 4, 'Trung binh'),
(4, 2, 'Cao');

INSERT INTO de_xuat_lo_trinh
(ma_nguoi_dung, ma_chu_de, mo_ta, trang_thai)
VALUES
(1, 3, 'On tap vong lap va lam them 5 bai tap', 'Dang hoc'),
(1, 4, 'Hoc lai mang mot chieu', 'Chua hoc'),
(4, 2, 'Luyen tap cau truc if else', 'Dang hoc');

-- =====================================================
-- 14. DIEN DAN, FAQ VA NHAT KY HE THONG
-- =====================================================

INSERT INTO chu_de_dien_dan
(ma_nguoi_dung, tieu_de, noi_dung, trang_thai)
VALUES
(1, 'Hoi ve vong lap C++', 'Em chua hieu vong lap for.',
 'Hien thi'),
(4, 'Cach tim loi chuong trinh', 'Cach kiem tra loi C++.',
 'Hien thi');

INSERT INTO bai_dang_dien_dan
(ma_chu_de_dien_dan, ma_nguoi_dung, noi_dung, parent_post_id)
VALUES
(1, 1, 'Em nen hoc vong lap for nhu the nao?', NULL),
(1, 2, 'Bat dau tu bai tap in cac so tu 1 den 10.', 1),
(2, 4, 'Hay kiem tra dau cham phay va dau ngoac.', NULL),
(1, 1, 'Em da hieu roi, em cam on!', 2);

INSERT INTO cau_hoi_thuong_gap
(cau_hoi, tra_loi, ma_nguoi_tao, trang_thai)
VALUES
('Lam sao de nop bai C++?',
 'Chon bai tap, nhap ma nguon va bam Nop bai.', 2, 'Hien thi'),
('Lam sao xem diem?',
 'Mo muc Ket qua hoc tap de xem diem.', 2, 'Hien thi'),
('Neu quen mat khau thi lam gi?',
 'Su dung chuc nang khoi phuc mat khau.', 3, 'Hien thi');

INSERT INTO nhat_ky_he_thong
(ma_nguoi_dung, hanh_dong, mo_ta)
VALUES
(3, 'TAO_KHOA_HOC', 'Tao khoa hoc Lap trinh C++ co ban'),
(3, 'QUAN_LY_TAI_KHOAN', 'Kiem tra danh sach nguoi dung'),
(2, 'TAO_BAI_TAP', 'Tao bai tap Tinh tong hai so');

-- =====================================================
-- 15. KIEM TRA DU LIEU
-- =====================================================

SHOW TABLES;

SELECT * FROM nguoi_dung;
SELECT * FROM vai_tro;
SELECT * FROM khoa_hoc;
SELECT * FROM bai_hoc;
SELECT * FROM bai_tap;
SELECT * FROM bai_nop;
SELECT * FROM ket_qua_cham;
SELECT * FROM chu_de;
SELECT * FROM bai_dang_dien_dan;
