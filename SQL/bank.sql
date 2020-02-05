-- phpMyAdmin SQL Dump
-- version 5.0.0
-- https://www.phpmyadmin.net/
--
-- Värd: 192.168.2.40:3306
-- Tid vid skapande: 05 feb 2020 kl 21:30
-- Serverversion: 10.5.0-MariaDB
-- PHP-version: 7.3.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Databas: `bank`
--

DELIMITER $$
--
-- Procedurer
--
CREATE DEFINER=`xavizus`@`%` PROCEDURE `createTransfer` (`amount_from` INT(11), `amount_to` INT(11), `from_user_id` INT(11), `to_user_id` INT(11), `currency_from` VARCHAR(255), `currency_to` VARCHAR(255), `ratio` FLOAT)  BEGIN
START TRANSACTION;

INSERT INTO `transactions` (`transaction_id`, `amount_from`, `from_user_id`, `to_user_id`, `date`, `currency_from`, `amount_to`, `currency_to`, `ratio`)
VALUES (NULL, amount_from, from_user_id, to_user_id, UNIX_TIMESTAMP(), currency_from, amount_to, currency_to, ratio);

UPDATE `balance` b
SET b.balance = b.balance - amount_from
WHERE b.balance_id in 
( 
SELECT b.balance_id
FROM balance b
LEFT JOIN userBalanceRelation ubr on b.balance_id = ubr.balance_id
LEFT JOIN `users` u on u.user_id = ubr.user_id
WHERE u.user_id = from_user_id
);

UPDATE `balance` b
SET b.balance = b.balance + amount_to
WHERE b.balance_id in 
( 
SELECT b.balance_id
FROM balance b
LEFT JOIN userBalanceRelation ubr on b.balance_id = ubr.balance_id
LEFT JOIN `users` u on u.user_id = ubr.user_id
WHERE u.user_id = to_user_id
);
COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tabellstruktur `balance`
--

CREATE TABLE `balance` (
  `balance_id` int(11) NOT NULL,
  `balance` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumpning av Data i tabell `balance`
--

INSERT INTO `balance` (`balance_id`, `balance`) VALUES
(1, 15881),
(2, 22999),
(3, 26157),
(4, 26529),
(5, 9709),
(6, 24592),
(7, 24067),
(8, 16174),
(9, 5741),
(10, 20106);

-- --------------------------------------------------------

--
-- Tabellstruktur `transactions`
--

CREATE TABLE `transactions` (
  `transaction_id` int(11) NOT NULL,
  `amount_from` int(11) NOT NULL,
  `from_user_id` int(11) NOT NULL,
  `to_user_id` int(11) NOT NULL,
  `date` int(11) NOT NULL,
  `currency_from` varchar(255) NOT NULL,
  `amount_to` int(11) NOT NULL,
  `currency_to` varchar(255) NOT NULL,
  `ratio` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumpning av Data i tabell `transactions`
--

INSERT INTO `transactions` (`transaction_id`, `amount_from`, `from_user_id`, `to_user_id`, `date`, `currency_from`, `amount_to`, `currency_to`, `ratio`) VALUES
(1, 644, 9, 7, 1557549534, 'SEK', 644, 'SEK', 1),
(2, 3672, 6, 2, 1576082416, 'SEK', 3672, 'SEK', 1),
(3, 3479, 5, 3, 1564455244, 'SEK', 3479, 'SEK', 1),
(4, 248, 9, 10, 1550252685, 'SEK', 248, 'SEK', 1),
(5, 3070, 4, 5, 1572427576, 'SEK', 3070, 'SEK', 1),
(6, 2431, 3, 8, 1566134598, 'SEK', 2431, 'SEK', 1),
(7, 245, 7, 10, 1567660486, 'SEK', 245, 'SEK', 1),
(8, 3316, 4, 8, 1551625296, 'SEK', 3316, 'SEK', 1),
(9, 1311, 10, 3, 1574368778, 'SEK', 1311, 'SEK', 1),
(10, 4216, 8, 10, 1557761331, 'SEK', 4216, 'SEK', 1),
(11, 4925, 7, 2, 1576648866, 'SEK', 4925, 'SEK', 1),
(12, 3424, 3, 9, 1566683272, 'SEK', 3424, 'SEK', 1),
(13, 4328, 2, 8, 1569205362, 'SEK', 4328, 'SEK', 1),
(14, 2287, 2, 3, 1576007923, 'SEK', 2287, 'SEK', 1),
(15, 3912, 5, 7, 1571379198, 'SEK', 3912, 'SEK', 1),
(16, 78, 3, 4, 1566591739, 'SEK', 78, 'SEK', 1),
(17, 4075, 1, 2, 1565585914, 'SEK', 4075, 'SEK', 1),
(18, 3041, 6, 3, 1560289105, 'SEK', 3041, 'SEK', 1),
(19, 819, 8, 4, 1553799230, 'SEK', 819, 'SEK', 1),
(20, 551, 5, 4, 1579055627, 'SEK', 551, 'SEK', 1),
(21, 342, 1, 4, 1572388415, 'SEK', 342, 'SEK', 1),
(22, 1387, 3, 2, 1554204269, 'SEK', 1387, 'SEK', 1),
(23, 4168, 1, 5, 1553638876, 'SEK', 4168, 'SEK', 1),
(24, 3333, 5, 4, 1578753550, 'SEK', 3333, 'SEK', 1),
(25, 3840, 6, 7, 1567249957, 'SEK', 3840, 'SEK', 1),
(26, 4281, 3, 2, 1575306368, 'SEK', 4281, 'SEK', 1),
(27, 2741, 6, 10, 1568278978, 'SEK', 2741, 'SEK', 1),
(28, 126, 2, 8, 1578265231, 'SEK', 126, 'SEK', 1),
(29, 3525, 6, 7, 1572590419, 'SEK', 3525, 'SEK', 1),
(30, 2076, 10, 2, 1568976638, 'SEK', 2076, 'SEK', 1),
(31, 3973, 1, 7, 1567800975, 'SEK', 3973, 'SEK', 1),
(32, 4920, 4, 5, 1556158275, 'SEK', 4920, 'SEK', 1),
(33, 3239, 7, 6, 1571658080, 'SEK', 3239, 'SEK', 1),
(34, 2018, 10, 4, 1559882094, 'SEK', 2018, 'SEK', 1),
(35, 1383, 7, 8, 1562521752, 'SEK', 1383, 'SEK', 1),
(36, 723, 9, 3, 1565198672, 'SEK', 723, 'SEK', 1),
(37, 2998, 3, 8, 1565593206, 'SEK', 2998, 'SEK', 1),
(38, 4599, 8, 2, 1562368878, 'SEK', 4599, 'SEK', 1),
(39, 2177, 8, 2, 1556717169, 'SEK', 2177, 'SEK', 1),
(40, 1061, 7, 4, 1550656852, 'SEK', 1061, 'SEK', 1),
(41, 1889, 1, 6, 1575006453, 'SEK', 1889, 'SEK', 1),
(42, 370, 4, 10, 1562152409, 'SEK', 370, 'SEK', 1),
(43, 3415, 10, 9, 1579718425, 'SEK', 3415, 'SEK', 1),
(44, 3642, 10, 5, 1564360432, 'SEK', 3642, 'SEK', 1),
(45, 2260, 2, 1, 1554314523, 'SEK', 2260, 'SEK', 1),
(46, 4269, 8, 10, 1566710817, 'SEK', 4269, 'SEK', 1),
(47, 3083, 9, 10, 1574313800, 'SEK', 3083, 'SEK', 1),
(48, 951, 7, 5, 1579985990, 'SEK', 951, 'SEK', 1),
(49, 1555, 2, 10, 1553212947, 'SEK', 1555, 'SEK', 1),
(50, 4954, 1, 7, 1564586161, 'SEK', 4954, 'SEK', 1),
(51, 2063, 8, 3, 1553914271, 'SEK', 2063, 'SEK', 1),
(52, 1909, 4, 6, 1560879183, 'SEK', 1909, 'SEK', 1),
(53, 4163, 4, 8, 1559988166, 'SEK', 4163, 'SEK', 1),
(54, 4490, 4, 1, 1576799741, 'SEK', 4490, 'SEK', 1),
(55, 754, 5, 9, 1574056594, 'SEK', 754, 'SEK', 1),
(56, 1858, 6, 2, 1553879571, 'SEK', 1858, 'SEK', 1),
(57, 1214, 5, 6, 1580468598, 'SEK', 1214, 'SEK', 1),
(58, 2169, 9, 6, 1570792959, 'SEK', 2169, 'SEK', 1),
(59, 593, 6, 10, 1551067896, 'SEK', 593, 'SEK', 1),
(60, 2672, 4, 1, 1561313405, 'SEK', 2672, 'SEK', 1),
(61, 2542, 2, 5, 1563917775, 'SEK', 2542, 'SEK', 1),
(62, 334, 7, 8, 1561773983, 'SEK', 334, 'SEK', 1),
(63, 1889, 10, 1, 1578994808, 'SEK', 1889, 'SEK', 1),
(64, 667, 4, 9, 1559108307, 'SEK', 667, 'SEK', 1),
(65, 803, 4, 5, 1577109410, 'SEK', 803, 'SEK', 1),
(66, 3699, 9, 2, 1565486252, 'SEK', 3699, 'SEK', 1),
(67, 4579, 2, 4, 1557145643, 'SEK', 4579, 'SEK', 1),
(68, 290, 8, 10, 1574492046, 'SEK', 290, 'SEK', 1),
(69, 4163, 10, 7, 1564789563, 'SEK', 4163, 'SEK', 1),
(70, 2735, 2, 6, 1553252448, 'SEK', 2735, 'SEK', 1),
(71, 3367, 7, 3, 1561594845, 'SEK', 3367, 'SEK', 1),
(72, 3194, 9, 2, 1549276925, 'SEK', 3194, 'SEK', 1),
(73, 2533, 8, 9, 1562931956, 'SEK', 2533, 'SEK', 1),
(74, 2199, 10, 9, 1580054959, 'SEK', 2199, 'SEK', 1),
(75, 4300, 6, 1, 1561902813, 'SEK', 4300, 'SEK', 1),
(76, 681, 9, 8, 1554317675, 'SEK', 681, 'SEK', 1),
(77, 4580, 7, 4, 1564512077, 'SEK', 4580, 'SEK', 1),
(78, 3440, 2, 3, 1573665998, 'SEK', 3440, 'SEK', 1),
(79, 2698, 1, 2, 1571573823, 'SEK', 2698, 'SEK', 1),
(80, 2482, 8, 9, 1552489577, 'SEK', 2482, 'SEK', 1),
(81, 955, 2, 4, 1557971625, 'SEK', 955, 'SEK', 1),
(82, 758, 1, 8, 1555657928, 'SEK', 758, 'SEK', 1),
(83, 2565, 7, 2, 1561857896, 'SEK', 2565, 'SEK', 1),
(84, 3290, 6, 3, 1552472427, 'SEK', 3290, 'SEK', 1),
(85, 3607, 6, 8, 1551799269, 'SEK', 3607, 'SEK', 1),
(86, 468, 7, 8, 1580222609, 'SEK', 468, 'SEK', 1),
(87, 511, 4, 1, 1550680644, 'SEK', 511, 'SEK', 1),
(88, 1269, 5, 1, 1568601679, 'SEK', 1269, 'SEK', 1),
(89, 1658, 9, 10, 1569201816, 'SEK', 1658, 'SEK', 1),
(90, 2419, 6, 3, 1576417493, 'SEK', 2419, 'SEK', 1),
(91, 4033, 2, 6, 1567428237, 'SEK', 4033, 'SEK', 1),
(92, 638, 1, 5, 1566157816, 'SEK', 638, 'SEK', 1),
(93, 3223, 10, 9, 1579891796, 'SEK', 3223, 'SEK', 1),
(94, 2157, 7, 5, 1562333263, 'SEK', 2157, 'SEK', 1),
(95, 585, 7, 9, 1574398744, 'SEK', 585, 'SEK', 1),
(96, 1450, 7, 10, 1567337992, 'SEK', 1450, 'SEK', 1),
(97, 3799, 1, 10, 1579465985, 'SEK', 3799, 'SEK', 1),
(98, 3366, 4, 9, 1566954270, 'SEK', 3366, 'SEK', 1),
(99, 2698, 3, 9, 1578799443, 'SEK', 2698, 'SEK', 1),
(100, 1559, 4, 5, 1549736887, 'SEK', 1559, 'SEK', 1),
(101, 4161, 5, 1, 1561912302, 'SEK', 4161, 'SEK', 1),
(102, 3409, 3, 4, 1574728886, 'SEK', 3409, 'SEK', 1),
(103, 1165, 1, 5, 1557148263, 'SEK', 1165, 'SEK', 1),
(104, 2477, 6, 10, 1556730055, 'SEK', 2477, 'SEK', 1),
(105, 4428, 6, 7, 1559801687, 'SEK', 4428, 'SEK', 1),
(106, 2041, 8, 6, 1560494893, 'SEK', 2041, 'SEK', 1),
(107, 4413, 2, 3, 1576097828, 'SEK', 4413, 'SEK', 1),
(108, 4504, 8, 3, 1576055305, 'SEK', 4504, 'SEK', 1),
(109, 4686, 5, 3, 1557717606, 'SEK', 4686, 'SEK', 1),
(110, 2969, 8, 3, 1573919959, 'SEK', 2969, 'SEK', 1),
(111, 746, 8, 7, 1576521130, 'SEK', 746, 'SEK', 1),
(112, 4583, 7, 3, 1550792173, 'SEK', 4583, 'SEK', 1),
(113, 348, 1, 9, 1576770080, 'SEK', 348, 'SEK', 1),
(114, 669, 9, 2, 1569208690, 'SEK', 669, 'SEK', 1),
(115, 4397, 6, 10, 1558815895, 'SEK', 4397, 'SEK', 1),
(116, 1980, 6, 7, 1552150822, 'SEK', 1980, 'SEK', 1),
(117, 4950, 8, 10, 1575940428, 'SEK', 4950, 'SEK', 1),
(118, 4464, 3, 4, 1560249984, 'SEK', 4464, 'SEK', 1),
(119, 2981, 10, 4, 1572131525, 'SEK', 2981, 'SEK', 1),
(120, 3874, 4, 8, 1551914940, 'SEK', 3874, 'SEK', 1),
(121, 2912, 1, 2, 1578093840, 'SEK', 2912, 'SEK', 1),
(122, 542, 5, 7, 1561364768, 'SEK', 542, 'SEK', 1),
(123, 1729, 6, 7, 1574596523, 'SEK', 1729, 'SEK', 1),
(124, 1367, 7, 4, 1577191850, 'SEK', 1367, 'SEK', 1),
(125, 118, 6, 8, 1550680603, 'SEK', 118, 'SEK', 1),
(126, 2311, 7, 8, 1549877079, 'SEK', 2311, 'SEK', 1),
(127, 3380, 9, 7, 1559682447, 'SEK', 3380, 'SEK', 1),
(128, 3022, 2, 3, 1574086585, 'SEK', 3022, 'SEK', 1),
(129, 646, 5, 1, 1568002990, 'SEK', 646, 'SEK', 1),
(130, 4046, 8, 7, 1579702970, 'SEK', 4046, 'SEK', 1),
(131, 61, 3, 4, 1571315775, 'SEK', 61, 'SEK', 1),
(132, 3987, 7, 5, 1568442355, 'SEK', 3987, 'SEK', 1),
(133, 4613, 4, 8, 1552723461, 'SEK', 4613, 'SEK', 1),
(134, 327, 7, 8, 1551928449, 'SEK', 327, 'SEK', 1),
(135, 1958, 2, 10, 1554488485, 'SEK', 1958, 'SEK', 1),
(136, 3112, 7, 9, 1557346597, 'SEK', 3112, 'SEK', 1),
(137, 244, 3, 8, 1571407676, 'SEK', 244, 'SEK', 1),
(138, 1409, 9, 7, 1570843810, 'SEK', 1409, 'SEK', 1),
(139, 1799, 10, 3, 1565068272, 'SEK', 1799, 'SEK', 1),
(140, 2348, 3, 5, 1562768117, 'SEK', 2348, 'SEK', 1),
(141, 4473, 1, 7, 1576639463, 'SEK', 4473, 'SEK', 1),
(142, 4762, 7, 4, 1552979835, 'SEK', 4762, 'SEK', 1),
(143, 2, 9, 10, 1570949625, 'SEK', 2, 'SEK', 1),
(144, 3395, 6, 1, 1549410855, 'SEK', 3395, 'SEK', 1),
(145, 2905, 7, 1, 1560587126, 'SEK', 2905, 'SEK', 1),
(146, 4103, 2, 7, 1562493484, 'SEK', 4103, 'SEK', 1),
(147, 436, 1, 2, 1553099553, 'SEK', 436, 'SEK', 1),
(148, 4008, 3, 4, 1575461611, 'SEK', 4008, 'SEK', 1),
(149, 139, 9, 7, 1556067774, 'SEK', 139, 'SEK', 1),
(150, 235, 5, 8, 1557068583, 'SEK', 235, 'SEK', 1),
(151, 3542, 4, 9, 1563128501, 'SEK', 3542, 'SEK', 1),
(152, 3522, 5, 8, 1564872410, 'SEK', 3522, 'SEK', 1),
(153, 858, 10, 7, 1550074292, 'SEK', 858, 'SEK', 1),
(154, 4902, 9, 10, 1564644072, 'SEK', 4902, 'SEK', 1),
(155, 4030, 5, 4, 1574295705, 'SEK', 4030, 'SEK', 1),
(156, 4881, 4, 7, 1570528625, 'SEK', 4881, 'SEK', 1),
(157, 3620, 10, 9, 1559230529, 'SEK', 3620, 'SEK', 1),
(158, 2067, 3, 2, 1570437075, 'SEK', 2067, 'SEK', 1),
(159, 2412, 3, 4, 1559875525, 'SEK', 2412, 'SEK', 1),
(160, 3844, 9, 10, 1573936550, 'SEK', 3844, 'SEK', 1),
(161, 4207, 1, 4, 1557119701, 'SEK', 4207, 'SEK', 1),
(162, 3105, 10, 7, 1564670332, 'SEK', 3105, 'SEK', 1),
(163, 746, 6, 7, 1564614789, 'SEK', 746, 'SEK', 1),
(164, 2559, 1, 6, 1574982024, 'SEK', 2559, 'SEK', 1),
(165, 4900, 7, 2, 1578865602, 'SEK', 4900, 'SEK', 1),
(166, 3654, 6, 4, 1556324317, 'SEK', 3654, 'SEK', 1),
(167, 754, 8, 7, 1552820569, 'SEK', 754, 'SEK', 1),
(168, 383, 7, 8, 1567507829, 'SEK', 383, 'SEK', 1),
(169, 3369, 1, 9, 1554646252, 'SEK', 3369, 'SEK', 1),
(170, 562, 10, 1, 1566126123, 'SEK', 562, 'SEK', 1),
(171, 425, 4, 5, 1576640368, 'SEK', 425, 'SEK', 1),
(172, 2165, 6, 5, 1572547102, 'SEK', 2165, 'SEK', 1),
(173, 3041, 5, 6, 1550998600, 'SEK', 3041, 'SEK', 1),
(174, 3655, 10, 3, 1565978818, 'SEK', 3655, 'SEK', 1),
(175, 678, 2, 10, 1566486461, 'SEK', 678, 'SEK', 1),
(176, 4911, 9, 4, 1560079275, 'SEK', 4911, 'SEK', 1),
(177, 1787, 6, 9, 1567557961, 'SEK', 1787, 'SEK', 1),
(178, 2601, 4, 5, 1555216248, 'SEK', 2601, 'SEK', 1),
(179, 1557, 3, 5, 1555162481, 'SEK', 1557, 'SEK', 1),
(180, 4665, 3, 10, 1552044310, 'SEK', 4665, 'SEK', 1),
(181, 421, 2, 5, 1561520025, 'SEK', 421, 'SEK', 1),
(182, 4945, 3, 8, 1571152507, 'SEK', 4945, 'SEK', 1),
(183, 2774, 6, 1, 1574432229, 'SEK', 2774, 'SEK', 1),
(184, 1949, 3, 1, 1563717215, 'SEK', 1949, 'SEK', 1),
(185, 2315, 10, 7, 1558526122, 'SEK', 2315, 'SEK', 1),
(186, 4286, 4, 9, 1557115125, 'SEK', 4286, 'SEK', 1),
(187, 3741, 4, 6, 1557367588, 'SEK', 3741, 'SEK', 1),
(188, 3430, 9, 10, 1575720557, 'SEK', 3430, 'SEK', 1),
(189, 816, 8, 9, 1551079072, 'SEK', 816, 'SEK', 1),
(190, 763, 3, 4, 1573355430, 'SEK', 763, 'SEK', 1),
(191, 1087, 9, 8, 1550097827, 'SEK', 1087, 'SEK', 1),
(192, 1117, 3, 2, 1564091583, 'SEK', 1117, 'SEK', 1),
(193, 4214, 4, 1, 1571508691, 'SEK', 4214, 'SEK', 1),
(194, 1280, 8, 9, 1564048926, 'SEK', 1280, 'SEK', 1),
(195, 1500, 7, 1, 1564105094, 'SEK', 1500, 'SEK', 1),
(196, 1417, 1, 7, 1563921737, 'SEK', 1417, 'SEK', 1),
(197, 2800, 10, 1, 1568864498, 'SEK', 2800, 'SEK', 1),
(198, 2078, 4, 7, 1566155934, 'SEK', 2078, 'SEK', 1),
(199, 1829, 2, 9, 1575796447, 'SEK', 1829, 'SEK', 1),
(200, 71, 6, 10, 1577781613, 'SEK', 71, 'SEK', 1),
(204, 10, 1, 2, 1580928568, 'SEK', 10, 'SEK', 1),
(205, 500, 1, 10, 1580929344, 'SEK', 52, 'USD', 0.104533),
(206, 100, 1, 2, 1580937562, 'SEK', 100, 'SEK', 1),
(207, 2000, 1, 2, 1580937963, 'SEK', 2000, 'SEK', 1),
(208, 1, 1, 2, 1580938130, 'SEK', 1, 'SEK', 1),
(209, 1, 1, 2, 1580938199, 'SEK', 1, 'SEK', 1);

-- --------------------------------------------------------

--
-- Tabellstruktur `userBalanceRelation`
--

CREATE TABLE `userBalanceRelation` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `balance_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumpning av Data i tabell `userBalanceRelation`
--

INSERT INTO `userBalanceRelation` (`id`, `user_id`, `balance_id`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10);

-- --------------------------------------------------------

--
-- Tabellstruktur `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `user_accountNumber` int(11) NOT NULL,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phoneNumber` varchar(255) NOT NULL,
  `creditCard` bigint(64) NOT NULL,
  `currency` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumpning av Data i tabell `users`
--

INSERT INTO `users` (`user_id`, `user_accountNumber`, `firstName`, `lastName`, `username`, `password`, `phoneNumber`, `creditCard`, `currency`) VALUES
(1, 3574737, 'Eugenius', 'McDougall', 'emcdougall0', 'MJvcqxlbNK', '0742468397', 3580744680863458, 'SEK'),
(2, 504172, 'Lion', 'Toyer', 'ltoyer1', '1HUTP8BivQ17', '0782379621', 6767417396615802383, 'SEK'),
(3, 760842, 'Blanca', 'Fussie', 'bfussie2', 'INdDBPs9UcW', '0776962414', 3580801426125236, 'SEK'),
(4, 4477385, 'Giffer', 'Wilstead', 'gwilstead3', 'fYz2Bs', '0757894112', 4026723369409338, 'SEK'),
(5, 9989952, 'Charlot', 'Waggatt', 'cwaggatt4', 'Qv69mr', '0765657961', 5100171216193802, 'SEK'),
(6, 6712260, 'Huberto', 'Biggs', 'hbiggs5', 'iVulMzUQ7v1', '0775385732', 3560938637496743, 'SEK'),
(7, 4819150, 'Drusi', 'Foskew', 'dfoskew6', '4pShbrXSpTLK', '0716149622', 3558332192426556, 'SEK'),
(8, 4475115, 'Sapphire', 'Vequaud', 'svequaud7', 'agN4Bzo3D', '0769354671', 4903224595848901500, 'SEK'),
(9, 396126, 'Stephannie', 'Gotfrey', 'sgotfrey8', '9LlRq8laWX', '0794316712', 4911824354926218693, 'SEK'),
(10, 7689146, 'Giulio', 'Arnli', 'garnli9', 'tSfZJjg', '0759219564', 5586260211506226, 'USD');

--
-- Index för dumpade tabeller
--

--
-- Index för tabell `balance`
--
ALTER TABLE `balance`
  ADD PRIMARY KEY (`balance_id`),
  ADD KEY `balance_id` (`balance_id`);

--
-- Index för tabell `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `from_user_id` (`from_user_id`,`to_user_id`),
  ADD KEY `to_user_id` (`to_user_id`);

--
-- Index för tabell `userBalanceRelation`
--
ALTER TABLE `userBalanceRelation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `user_id` (`user_id`,`balance_id`),
  ADD KEY `balance_id` (`balance_id`);

--
-- Index för tabell `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT för dumpade tabeller
--

--
-- AUTO_INCREMENT för tabell `balance`
--
ALTER TABLE `balance`
  MODIFY `balance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT för tabell `transactions`
--
ALTER TABLE `transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=210;

--
-- AUTO_INCREMENT för tabell `userBalanceRelation`
--
ALTER TABLE `userBalanceRelation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT för tabell `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- Restriktioner för dumpade tabeller
--

--
-- Restriktioner för tabell `balance`
--
ALTER TABLE `balance`
  ADD CONSTRAINT `balance_ibfk_1` FOREIGN KEY (`balance_id`) REFERENCES `userBalanceRelation` (`balance_id`);

--
-- Restriktioner för tabell `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`user_id`);

--
-- Restriktioner för tabell `userBalanceRelation`
--
ALTER TABLE `userBalanceRelation`
  ADD CONSTRAINT `userBalanceRelation_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

