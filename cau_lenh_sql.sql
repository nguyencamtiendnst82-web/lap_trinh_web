
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

CREATE TABLE `topics` (

  `topic_id` int NOT NULL AUTO_INCREMENT,

  `topic_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,

  `description` text COLLATE utf8mb4_unicode_ci,

  PRIMARY KEY (`topic_id`)

) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `users` (

  `user_id` int NOT NULL AUTO_INCREMENT,

  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,

  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,

  `status` tinyint(1) DEFAULT '1',

  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,

  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  `role` enum('STUDENT','TEACHER','ADMIN') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'STUDENT',

  PRIMARY KEY (`user_id`),

  UNIQUE KEY `email` (`email`)

) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `learning_path_recommendations` (

  `recommendation_id` int NOT NULL AUTO_INCREMENT,

  `user_id` int NOT NULL,

  `topic_id` int NOT NULL,

  `description` text COLLATE utf8mb4_unicode_ci,

  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,

  `status` enum('NOT_STARTED','IN_PROGRESS','COMPLETED') COLLATE utf8mb4_unicode_ci DEFAULT 'NOT_STARTED',

  PRIMARY KEY (`recommendation_id`),

  KEY `user_id` (`user_id`),

  KEY `topic_id` (`topic_id`),

  CONSTRAINT `fk_de_xuat_lo_trinh_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),

  CONSTRAINT `fk_de_xuat_lo_trinh_2` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`topic_id`)

) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `topic_scores` (

  `score_id` int NOT NULL AUTO_INCREMENT,

  `user_id` int NOT NULL,

  `topic_id` int NOT NULL,

  `average_score` decimal(5,2) DEFAULT '0.00',

  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`score_id`),

  UNIQUE KEY `user_id` (`user_id`,`topic_id`),

  KEY `topic_id` (`topic_id`),

  CONSTRAINT `fk_diem_theo_chu_de_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),

  CONSTRAINT `fk_diem_theo_chu_de_2` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`topic_id`)

) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `courses` (

  `course_id` int NOT NULL AUTO_INCREMENT,

  `course_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,

  `description` text COLLATE utf8mb4_unicode_ci,

  `difficulty` enum('EASY','MEDIUM','HARD') COLLATE utf8mb4_unicode_ci DEFAULT 'MEDIUM',

  `expert_id` int DEFAULT NULL,

  `status` enum('PENDING_APPROVAL','OPEN','CLOSED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING_APPROVAL',

  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,

  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`course_id`),

  KEY `expert_id` (`expert_id`),

  CONSTRAINT `fk_khoa_hoc_1` FOREIGN KEY (`expert_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL

) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `weakness_analyses` (

  `analysis_id` int NOT NULL AUTO_INCREMENT,

  `user_id` int NOT NULL,

  `topic_id` int NOT NULL,

  `weakness_level` enum('LOW','MEDIUM','HIGH') COLLATE utf8mb4_unicode_ci DEFAULT 'MEDIUM',

  `analyzed_at` datetime DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`analysis_id`),

  KEY `user_id` (`user_id`),

  KEY `topic_id` (`topic_id`),

  CONSTRAINT `fk_phan_tich_diem_yeu_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),

  CONSTRAINT `fk_phan_tich_diem_yeu_2` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`topic_id`)

) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `lessons` (

  `lesson_id` int NOT NULL AUTO_INCREMENT,

  `course_id` int NOT NULL,

  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,

  `content` text COLLATE utf8mb4_unicode_ci,

  `sample_example` text COLLATE utf8mb4_unicode_ci,

  `position` int DEFAULT '1',

  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`lesson_id`),

  KEY `course_id` (`course_id`),

  CONSTRAINT `fk_bai_hoc_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `exercises` (

  `exercise_id` int NOT NULL AUTO_INCREMENT,

  `lesson_id` int NOT NULL,

  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,

  `description` text COLLATE utf8mb4_unicode_ci,

  `difficulty` enum('EASY','MEDIUM','HARD') COLLATE utf8mb4_unicode_ci DEFAULT 'MEDIUM',

  `programming_language` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'C++',

  `expert_id` int DEFAULT NULL,

  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`exercise_id`),

  KEY `lesson_id` (`lesson_id`),

  KEY `expert_id` (`expert_id`),

  CONSTRAINT `fk_bai_tap_1` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`lesson_id`) ON DELETE CASCADE,

  CONSTRAINT `fk_bai_tap_2` FOREIGN KEY (`expert_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL

) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `exercise_topics` (

  `exercise_id` int NOT NULL,

  `topic_id` int NOT NULL,

  PRIMARY KEY (`exercise_id`,`topic_id`),

  KEY `topic_id` (`topic_id`),

  CONSTRAINT `fk_bai_tap_chu_de_1` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`exercise_id`) ON DELETE CASCADE,

  CONSTRAINT `fk_bai_tap_chu_de_2` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`topic_id`) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `test_cases` (

  `test_case_id` int NOT NULL AUTO_INCREMENT,

  `exercise_id` int NOT NULL,

  `input_data` text COLLATE utf8mb4_unicode_ci,

  `expected_output` text COLLATE utf8mb4_unicode_ci,

  `is_sample` tinyint(1) DEFAULT '0',

  PRIMARY KEY (`test_case_id`),

  KEY `exercise_id` (`exercise_id`),

  CONSTRAINT `fk_ca_kiem_thu_1` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`exercise_id`) ON DELETE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `quiz_questions` (

  `question_id` int NOT NULL AUTO_INCREMENT,

  `lesson_id` int NOT NULL,

  `question_text` text COLLATE utf8mb4_unicode_ci NOT NULL,

  `question_type` enum('MULTIPLE_CHOICE','ESSAY') COLLATE utf8mb4_unicode_ci DEFAULT 'MULTIPLE_CHOICE',

  `points` decimal(5,2) DEFAULT '1.00',

  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`question_id`),

  KEY `lesson_id` (`lesson_id`),

  CONSTRAINT `fk_cau_hoi_trac_nghiem_1` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`lesson_id`) ON DELETE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `course_enrollments` (

  `enrollment_id` int NOT NULL AUTO_INCREMENT,

  `user_id` int NOT NULL,

  `course_id` int NOT NULL,

  `enrolled_at` datetime DEFAULT CURRENT_TIMESTAMP,

  `status` enum('IN_PROGRESS','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'IN_PROGRESS',

  PRIMARY KEY (`enrollment_id`),

  UNIQUE KEY `user_id` (`user_id`,`course_id`),

  KEY `course_id` (`course_id`),

  CONSTRAINT `fk_dang_ky_khoa_hoc_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),

  CONSTRAINT `fk_dang_ky_khoa_hoc_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`)

) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `answer_options` (

  `option_id` int NOT NULL AUTO_INCREMENT,

  `question_id` int NOT NULL,

  `option_text` text COLLATE utf8mb4_unicode_ci NOT NULL,

  `is_correct` tinyint(1) DEFAULT '0',

  PRIMARY KEY (`option_id`),

  KEY `question_id` (`question_id`),

  CONSTRAINT `fk_phuong_an_1` FOREIGN KEY (`question_id`) REFERENCES `quiz_questions` (`question_id`) ON DELETE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `learning_progress` (

  `progress_id` int NOT NULL AUTO_INCREMENT,

  `user_id` int NOT NULL,

  `lesson_id` int NOT NULL,

  `is_completed` tinyint(1) DEFAULT '0',

  `completed_at` datetime DEFAULT NULL,

  PRIMARY KEY (`progress_id`),

  UNIQUE KEY `user_id` (`user_id`,`lesson_id`),

  KEY `lesson_id` (`lesson_id`),

  CONSTRAINT `fk_tien_do_hoc_tap_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),

  CONSTRAINT `fk_tien_do_hoc_tap_2` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`lesson_id`) ON DELETE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `submissions` (

  `submission_id` int NOT NULL AUTO_INCREMENT,

  `user_id` int NOT NULL,

  `exercise_id` int NOT NULL,

  `source_code` text COLLATE utf8mb4_unicode_ci NOT NULL,

  `programming_language` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'C++',

  `submitted_at` datetime DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`submission_id`),

  KEY `user_id` (`user_id`),

  KEY `exercise_id` (`exercise_id`),

  CONSTRAINT `fk_bai_nop_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),

  CONSTRAINT `fk_bai_nop_2` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`exercise_id`)

) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `grading_results` (

  `result_id` int NOT NULL AUTO_INCREMENT,

  `submission_id` int NOT NULL,

  `score` decimal(5,2) DEFAULT '0.00',

  `status` enum('PASSED','FAILED','ERROR') COLLATE utf8mb4_unicode_ci DEFAULT 'ERROR',

  `execution_time_ms` int DEFAULT NULL,

  `error_message` text COLLATE utf8mb4_unicode_ci,

  `graded_at` datetime DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`result_id`),

  KEY `submission_id` (`submission_id`),

  CONSTRAINT `fk_ket_qua_cham_1` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `quiz_attempts` (

  `attempt_id` int NOT NULL AUTO_INCREMENT,

  `user_id` int NOT NULL,

  `question_id` int NOT NULL,

  `selected_option_id` int DEFAULT NULL,

  `is_correct` tinyint(1) DEFAULT '0',

  `answered_at` datetime DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`attempt_id`),

  KEY `user_id` (`user_id`),

  KEY `question_id` (`question_id`),

  KEY `selected_option_id` (`selected_option_id`),

  CONSTRAINT `fk_lan_lam_bai_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),

  CONSTRAINT `fk_lan_lam_bai_2` FOREIGN KEY (`question_id`) REFERENCES `quiz_questions` (`question_id`),

  CONSTRAINT `fk_lan_lam_bai_3` FOREIGN KEY (`selected_option_id`) REFERENCES `answer_options` (`option_id`) ON DELETE SET NULL

) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
