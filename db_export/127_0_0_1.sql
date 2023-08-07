-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 07, 2023 at 05:01 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `oopl`
--
CREATE DATABASE IF NOT EXISTS `oopl` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `oopl`;

-- --------------------------------------------------------

--
-- Table structure for table `charges`
--

CREATE TABLE `charges` (
  `charge_id` bigint(20) NOT NULL,
  `charge_value` int(11) NOT NULL,
  `total_hours` int(11) NOT NULL,
  `entry_datetime` datetime NOT NULL,
  `exit_datetime` datetime DEFAULT NULL,
  `record_id` bigint(20) NOT NULL,
  `size_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `distances`
--

CREATE TABLE `distances` (
  `distance_id` bigint(20) NOT NULL,
  `entry_point_id` bigint(20) NOT NULL,
  `slot_id` bigint(20) NOT NULL,
  `distance` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `distances`
--

INSERT INTO `distances` (`distance_id`, `entry_point_id`, `slot_id`, `distance`) VALUES
(1225, 60, 569, 1.4142135623730951),
(1226, 61, 569, 14.7648230602334),
(1227, 62, 569, 13.038404810405298),
(1228, 60, 570, 2.23606797749979),
(1229, 61, 570, 13.892443989449804),
(1230, 62, 570, 13.152946437965905),
(1231, 60, 571, 3.1622776601683795),
(1232, 61, 571, 13.038404810405298),
(1233, 62, 571, 13.341664064126334),
(1234, 60, 572, 4.123105625617661),
(1235, 61, 572, 12.206555615733702),
(1236, 62, 572, 13.601470508735444),
(1237, 60, 573, 5.0990195135927845),
(1238, 61, 573, 11.40175425099138),
(1239, 62, 573, 13.92838827718412),
(1240, 60, 574, 6.082762530298219),
(1241, 61, 574, 10.63014581273465),
(1242, 62, 574, 14.317821063276353),
(1243, 60, 575, 7.0710678118654755),
(1244, 61, 575, 9.899494936611665),
(1245, 62, 575, 14.7648230602334),
(1246, 60, 576, 8.06225774829855),
(1247, 61, 576, 9.219544457292887),
(1248, 62, 576, 15.264337522473747),
(1249, 60, 577, 9.055385138137417),
(1250, 61, 577, 8.602325267042627),
(1251, 62, 577, 15.811388300841896),
(1252, 60, 578, 10.04987562112089),
(1253, 61, 578, 8.06225774829855),
(1254, 62, 578, 16.401219466856727),
(1255, 60, 579, 11.045361017187261),
(1256, 61, 579, 7.615773105863909),
(1257, 62, 579, 17.029386365926403),
(1258, 60, 580, 12.041594578792296),
(1259, 61, 580, 7.280109889280518),
(1260, 62, 580, 17.69180601295413),
(1261, 60, 581, 13.038404810405298),
(1262, 61, 581, 7.0710678118654755),
(1263, 62, 581, 18.384776310850235),
(1264, 60, 582, 1.4142135623730951),
(1265, 61, 582, 13.92838827718412),
(1266, 62, 582, 11.045361017187261),
(1267, 60, 583, 3.1622776601683795),
(1268, 61, 583, 12.083045973594572),
(1269, 62, 583, 11.40175425099138),
(1270, 60, 584, 4.123105625617661),
(1271, 61, 584, 11.180339887498949),
(1272, 62, 584, 11.704699910719626),
(1273, 60, 585, 6.082762530298219),
(1274, 61, 585, 9.433981132056603),
(1275, 62, 585, 12.529964086141668),
(1276, 60, 586, 7.0710678118654755),
(1277, 61, 586, 8.602325267042627),
(1278, 62, 586, 13.038404810405298),
(1279, 60, 587, 9.055385138137417),
(1280, 61, 587, 7.0710678118654755),
(1281, 62, 587, 14.212670403551895),
(1282, 60, 588, 10.04987562112089),
(1283, 61, 588, 6.4031242374328485),
(1284, 62, 588, 14.866068747318506),
(1285, 60, 589, 11.045361017187261),
(1286, 61, 589, 5.830951894845301),
(1287, 62, 589, 15.556349186104045),
(1288, 60, 590, 12.041594578792296),
(1289, 61, 590, 5.385164807134504),
(1290, 62, 590, 16.278820596099706),
(1291, 60, 591, 2.23606797749979),
(1292, 61, 591, 13.601470508735444),
(1293, 62, 591, 10.04987562112089),
(1294, 60, 592, 3.605551275463989),
(1295, 61, 592, 11.704699910719626),
(1296, 62, 592, 10.44030650891055),
(1297, 60, 593, 4.47213595499958),
(1298, 61, 593, 10.770329614269007),
(1299, 62, 593, 10.770329614269007),
(1300, 60, 594, 6.324555320336759),
(1301, 61, 594, 8.94427190999916),
(1302, 62, 594, 11.661903789690601),
(1303, 60, 595, 7.280109889280518),
(1304, 61, 595, 8.06225774829855),
(1305, 62, 595, 12.206555615733702),
(1306, 60, 596, 3.1622776601683795),
(1307, 61, 596, 13.341664064126334),
(1308, 62, 596, 9.055385138137417),
(1309, 60, 597, 4.242640687119285),
(1310, 61, 597, 11.40175425099138),
(1311, 62, 597, 9.486832980505138),
(1312, 60, 598, 5),
(1313, 61, 598, 10.44030650891055),
(1314, 62, 598, 9.848857801796104),
(1315, 60, 599, 6.708203932499369),
(1316, 61, 599, 8.54400374531753),
(1317, 62, 599, 10.816653826391969),
(1318, 60, 600, 7.615773105863909),
(1319, 61, 600, 7.615773105863909),
(1320, 62, 600, 11.40175425099138),
(1321, 60, 601, 4.123105625617661),
(1322, 61, 601, 13.152946437965905),
(1323, 62, 601, 8.06225774829855),
(1324, 60, 602, 5),
(1325, 61, 602, 11.180339887498949),
(1326, 62, 602, 8.54400374531753),
(1327, 60, 603, 5.656854249492381),
(1328, 61, 603, 10.198039027185569),
(1329, 62, 603, 8.94427190999916),
(1330, 60, 604, 7.211102550927978),
(1331, 61, 604, 8.246211251235321),
(1332, 62, 604, 10),
(1333, 60, 605, 8.06225774829855),
(1334, 61, 605, 7.280109889280518),
(1335, 62, 605, 10.63014581273465),
(1336, 60, 606, 9.848857801796104),
(1337, 61, 606, 5.385164807134504),
(1338, 62, 606, 12.041594578792296),
(1339, 60, 607, 10.770329614269007),
(1340, 61, 607, 4.47213595499958),
(1341, 62, 607, 12.806248474865697),
(1342, 60, 608, 11.704699910719626),
(1343, 61, 608, 3.605551275463989),
(1344, 62, 608, 13.601470508735444),
(1345, 60, 609, 12.649110640673518),
(1346, 61, 609, 2.8284271247461903),
(1347, 62, 609, 14.422205101855956),
(1348, 60, 610, 5.0990195135927845),
(1349, 61, 610, 13.038404810405298),
(1350, 62, 610, 7.0710678118654755),
(1351, 60, 611, 5.830951894845301),
(1352, 61, 611, 11.045361017187261),
(1353, 62, 611, 7.615773105863909),
(1354, 60, 612, 6.4031242374328485),
(1355, 61, 612, 10.04987562112089),
(1356, 62, 612, 8.06225774829855),
(1357, 60, 613, 7.810249675906654),
(1358, 61, 613, 8.06225774829855),
(1359, 62, 613, 9.219544457292887),
(1360, 60, 614, 8.602325267042627),
(1361, 61, 614, 7.0710678118654755),
(1362, 62, 614, 9.899494936611665),
(1363, 60, 615, 6.082762530298219),
(1364, 61, 615, 13),
(1365, 62, 615, 6.082762530298219),
(1366, 60, 616, 6.708203932499369),
(1367, 61, 616, 11),
(1368, 62, 616, 6.708203932499369),
(1369, 60, 617, 7.211102550927978),
(1370, 61, 617, 10),
(1371, 62, 617, 7.211102550927978),
(1372, 60, 618, 8.48528137423857),
(1373, 61, 618, 8),
(1374, 62, 618, 8.48528137423857),
(1375, 60, 619, 9.219544457292887),
(1376, 61, 619, 7),
(1377, 62, 619, 9.219544457292887),
(1378, 60, 620, 7.0710678118654755),
(1379, 61, 620, 13.038404810405298),
(1380, 62, 620, 5.0990195135927845),
(1381, 60, 621, 7.615773105863909),
(1382, 61, 621, 11.045361017187261),
(1383, 62, 621, 5.830951894845301),
(1384, 60, 622, 8.06225774829855),
(1385, 61, 622, 10.04987562112089),
(1386, 62, 622, 6.4031242374328485),
(1387, 60, 623, 9.219544457292887),
(1388, 61, 623, 8.06225774829855),
(1389, 62, 623, 7.810249675906654),
(1390, 60, 624, 9.899494936611665),
(1391, 61, 624, 7.0710678118654755),
(1392, 62, 624, 8.602325267042627),
(1393, 60, 625, 8.06225774829855),
(1394, 61, 625, 13.152946437965905),
(1395, 62, 625, 4.123105625617661),
(1396, 60, 626, 8.54400374531753),
(1397, 61, 626, 11.180339887498949),
(1398, 62, 626, 5),
(1399, 60, 627, 8.94427190999916),
(1400, 61, 627, 10.198039027185569),
(1401, 62, 627, 5.656854249492381),
(1402, 60, 628, 10),
(1403, 61, 628, 8.246211251235321),
(1404, 62, 628, 7.211102550927978),
(1405, 60, 629, 10.63014581273465),
(1406, 61, 629, 7.280109889280518),
(1407, 62, 629, 8.06225774829855),
(1408, 60, 630, 12.041594578792296),
(1409, 61, 630, 5.385164807134504),
(1410, 62, 630, 9.848857801796104),
(1411, 60, 631, 12.806248474865697),
(1412, 61, 631, 4.47213595499958),
(1413, 62, 631, 10.770329614269007),
(1414, 60, 632, 13.601470508735444),
(1415, 61, 632, 3.605551275463989),
(1416, 62, 632, 11.704699910719626),
(1417, 60, 633, 14.422205101855956),
(1418, 61, 633, 2.8284271247461903),
(1419, 62, 633, 12.649110640673518),
(1420, 60, 634, 9.055385138137417),
(1421, 61, 634, 13.341664064126334),
(1422, 62, 634, 3.1622776601683795),
(1423, 60, 635, 9.486832980505138),
(1424, 61, 635, 11.40175425099138),
(1425, 62, 635, 4.242640687119285),
(1426, 60, 636, 9.848857801796104),
(1427, 61, 636, 10.44030650891055),
(1428, 62, 636, 5),
(1429, 60, 637, 10.816653826391969),
(1430, 61, 637, 8.54400374531753),
(1431, 62, 637, 6.708203932499369),
(1432, 60, 638, 11.40175425099138),
(1433, 61, 638, 7.615773105863909),
(1434, 62, 638, 7.615773105863909),
(1435, 60, 639, 10.04987562112089),
(1436, 61, 639, 13.601470508735444),
(1437, 62, 639, 2.23606797749979),
(1438, 60, 640, 10.44030650891055),
(1439, 61, 640, 11.704699910719626),
(1440, 62, 640, 3.605551275463989),
(1441, 60, 641, 10.770329614269007),
(1442, 61, 641, 10.770329614269007),
(1443, 62, 641, 4.47213595499958),
(1444, 60, 642, 11.661903789690601),
(1445, 61, 642, 8.94427190999916),
(1446, 62, 642, 6.324555320336759),
(1447, 60, 643, 12.206555615733702),
(1448, 61, 643, 8.06225774829855),
(1449, 62, 643, 7.280109889280518),
(1450, 60, 644, 11.045361017187261),
(1451, 61, 644, 13.92838827718412),
(1452, 62, 644, 1.4142135623730951),
(1453, 60, 645, 11.40175425099138),
(1454, 61, 645, 12.083045973594572),
(1455, 62, 645, 3.1622776601683795),
(1456, 60, 646, 11.704699910719626),
(1457, 61, 646, 11.180339887498949),
(1458, 62, 646, 4.123105625617661),
(1459, 60, 647, 12.529964086141668),
(1460, 61, 647, 9.433981132056603),
(1461, 62, 647, 6.082762530298219),
(1462, 60, 648, 13.038404810405298),
(1463, 61, 648, 8.602325267042627),
(1464, 62, 648, 7.0710678118654755),
(1465, 60, 649, 14.212670403551895),
(1466, 61, 649, 7.0710678118654755),
(1467, 62, 649, 9.055385138137417),
(1468, 60, 650, 14.866068747318506),
(1469, 61, 650, 6.4031242374328485),
(1470, 62, 650, 10.04987562112089),
(1471, 60, 651, 15.556349186104045),
(1472, 61, 651, 5.830951894845301),
(1473, 62, 651, 11.045361017187261),
(1474, 60, 652, 16.278820596099706),
(1475, 61, 652, 5.385164807134504),
(1476, 62, 652, 12.041594578792296),
(1477, 60, 653, 13.038404810405298),
(1478, 61, 653, 14.7648230602334),
(1479, 62, 653, 1.4142135623730951),
(1480, 60, 654, 13.152946437965905),
(1481, 61, 654, 13.892443989449804),
(1482, 62, 654, 2.23606797749979),
(1483, 60, 655, 13.341664064126334),
(1484, 61, 655, 13.038404810405298),
(1485, 62, 655, 3.1622776601683795),
(1486, 60, 656, 13.601470508735444),
(1487, 61, 656, 12.206555615733702),
(1488, 62, 656, 4.123105625617661),
(1489, 60, 657, 13.92838827718412),
(1490, 61, 657, 11.40175425099138),
(1491, 62, 657, 5.0990195135927845),
(1492, 60, 658, 14.317821063276353),
(1493, 61, 658, 10.63014581273465),
(1494, 62, 658, 6.082762530298219),
(1495, 60, 659, 14.7648230602334),
(1496, 61, 659, 9.899494936611665),
(1497, 62, 659, 7.0710678118654755),
(1498, 60, 660, 15.264337522473747),
(1499, 61, 660, 9.219544457292887),
(1500, 62, 660, 8.06225774829855),
(1501, 60, 661, 15.811388300841896),
(1502, 61, 661, 8.602325267042627),
(1503, 62, 661, 9.055385138137417),
(1504, 60, 662, 16.401219466856727),
(1505, 61, 662, 8.06225774829855),
(1506, 62, 662, 10.04987562112089),
(1507, 60, 663, 17.029386365926403),
(1508, 61, 663, 7.615773105863909),
(1509, 62, 663, 11.045361017187261),
(1510, 60, 664, 17.69180601295413),
(1511, 61, 664, 7.280109889280518),
(1512, 62, 664, 12.041594578792296),
(1513, 60, 665, 18.384776310850235),
(1514, 61, 665, 7.0710678118654755),
(1515, 62, 665, 13.038404810405298),
(1525, 66, 669, 2),
(1526, 67, 669, 2.23606797749979),
(1527, 68, 669, 2.8284271247461903),
(1528, 66, 670, 2.23606797749979),
(1529, 67, 670, 2),
(1530, 68, 670, 2.23606797749979),
(1531, 66, 671, 2.8284271247461903),
(1532, 67, 671, 2.23606797749979),
(1533, 68, 671, 2);

-- --------------------------------------------------------

--
-- Table structure for table `entry_points`
--

CREATE TABLE `entry_points` (
  `entry_point_id` bigint(20) NOT NULL,
  `entry_point_x` int(11) NOT NULL,
  `entry_point_y` int(11) NOT NULL,
  `parking_lot_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `entry_points`
--

INSERT INTO `entry_points` (`entry_point_id`, `entry_point_x`, `entry_point_y`, `parking_lot_id`) VALUES
(60, 0, 1, 1),
(61, 14, 7, 1),
(62, 0, 13, 1),
(66, 6, 4, 3),
(67, 7, 4, 3),
(68, 8, 4, 3);

-- --------------------------------------------------------

--
-- Table structure for table `parking_lots`
--

CREATE TABLE `parking_lots` (
  `parking_lot_id` bigint(20) NOT NULL,
  `parking_lot_name` text NOT NULL,
  `total_earnings` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parking_lots`
--

INSERT INTO `parking_lots` (`parking_lot_id`, `parking_lot_name`, `total_earnings`) VALUES
(1, 'TEST LOT 1', 0),
(2, 'Empty LOT', 0),
(3, 'TEST LOT 3', 0),
(4, 'FREE LOT ', 0),
(5, 'LOT NUMBER 5', 0);

-- --------------------------------------------------------

--
-- Table structure for table `parking_records`
--

CREATE TABLE `parking_records` (
  `record_id` bigint(20) NOT NULL,
  `vehicle_id` bigint(20) NOT NULL,
  `entry_datetime` datetime NOT NULL,
  `exit_datetime` datetime DEFAULT NULL,
  `parking_lot_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `parking_slots`
--

CREATE TABLE `parking_slots` (
  `slot_id` bigint(20) NOT NULL,
  `slot_x` int(11) NOT NULL,
  `slot_y` int(11) NOT NULL,
  `size_id` bigint(20) NOT NULL,
  `parking_lot_id` bigint(20) NOT NULL,
  `vehicle_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parking_slots`
--

INSERT INTO `parking_slots` (`slot_id`, `slot_x`, `slot_y`, `size_id`, `parking_lot_id`, `vehicle_id`) VALUES
(569, 1, 0, 1, 1, NULL),
(570, 2, 0, 1, 1, NULL),
(571, 3, 0, 1, 1, NULL),
(572, 4, 0, 1, 1, NULL),
(573, 5, 0, 1, 1, NULL),
(574, 6, 0, 1, 1, NULL),
(575, 7, 0, 1, 1, NULL),
(576, 8, 0, 3, 1, NULL),
(577, 9, 0, 3, 1, NULL),
(578, 10, 0, 3, 1, NULL),
(579, 11, 0, 3, 1, NULL),
(580, 12, 0, 3, 1, NULL),
(581, 13, 0, 3, 1, NULL),
(582, 1, 2, 1, 1, NULL),
(583, 3, 2, 1, 1, NULL),
(584, 4, 2, 2, 1, NULL),
(585, 6, 2, 2, 1, NULL),
(586, 7, 2, 2, 1, NULL),
(587, 9, 2, 3, 1, NULL),
(588, 10, 2, 3, 1, NULL),
(589, 11, 2, 3, 1, NULL),
(590, 12, 2, 3, 1, NULL),
(591, 1, 3, 1, 1, NULL),
(592, 3, 3, 1, 1, NULL),
(593, 4, 3, 2, 1, NULL),
(594, 6, 3, 2, 1, NULL),
(595, 7, 3, 2, 1, NULL),
(596, 1, 4, 1, 1, NULL),
(597, 3, 4, 1, 1, NULL),
(598, 4, 4, 2, 1, NULL),
(599, 6, 4, 2, 1, NULL),
(600, 7, 4, 2, 1, NULL),
(601, 1, 5, 1, 1, NULL),
(602, 3, 5, 1, 1, NULL),
(603, 4, 5, 2, 1, NULL),
(604, 6, 5, 2, 1, NULL),
(605, 7, 5, 2, 1, NULL),
(606, 9, 5, 3, 1, NULL),
(607, 10, 5, 3, 1, NULL),
(608, 11, 5, 3, 1, NULL),
(609, 12, 5, 3, 1, NULL),
(610, 1, 6, 1, 1, NULL),
(611, 3, 6, 1, 1, NULL),
(612, 4, 6, 2, 1, NULL),
(613, 6, 6, 2, 1, NULL),
(614, 7, 6, 2, 1, NULL),
(615, 1, 7, 1, 1, NULL),
(616, 3, 7, 1, 1, NULL),
(617, 4, 7, 2, 1, NULL),
(618, 6, 7, 2, 1, NULL),
(619, 7, 7, 2, 1, NULL),
(620, 1, 8, 1, 1, NULL),
(621, 3, 8, 1, 1, NULL),
(622, 4, 8, 2, 1, NULL),
(623, 6, 8, 2, 1, NULL),
(624, 7, 8, 2, 1, NULL),
(625, 1, 9, 1, 1, NULL),
(626, 3, 9, 1, 1, NULL),
(627, 4, 9, 2, 1, NULL),
(628, 6, 9, 2, 1, NULL),
(629, 7, 9, 2, 1, NULL),
(630, 9, 9, 3, 1, NULL),
(631, 10, 9, 3, 1, NULL),
(632, 11, 9, 3, 1, NULL),
(633, 12, 9, 3, 1, NULL),
(634, 1, 10, 1, 1, NULL),
(635, 3, 10, 1, 1, NULL),
(636, 4, 10, 2, 1, NULL),
(637, 6, 10, 2, 1, NULL),
(638, 7, 10, 2, 1, NULL),
(639, 1, 11, 1, 1, NULL),
(640, 3, 11, 1, 1, NULL),
(641, 4, 11, 2, 1, NULL),
(642, 6, 11, 2, 1, NULL),
(643, 7, 11, 2, 1, NULL),
(644, 1, 12, 1, 1, NULL),
(645, 3, 12, 1, 1, NULL),
(646, 4, 12, 2, 1, NULL),
(647, 6, 12, 2, 1, NULL),
(648, 7, 12, 2, 1, NULL),
(649, 9, 12, 3, 1, NULL),
(650, 10, 12, 3, 1, NULL),
(651, 11, 12, 3, 1, NULL),
(652, 12, 12, 3, 1, NULL),
(653, 1, 14, 1, 1, NULL),
(654, 2, 14, 1, 1, NULL),
(655, 3, 14, 1, 1, NULL),
(656, 4, 14, 1, 1, NULL),
(657, 5, 14, 1, 1, NULL),
(658, 6, 14, 1, 1, NULL),
(659, 7, 14, 1, 1, NULL),
(660, 8, 14, 3, 1, NULL),
(661, 9, 14, 3, 1, NULL),
(662, 10, 14, 3, 1, NULL),
(663, 11, 14, 3, 1, NULL),
(664, 12, 14, 3, 1, NULL),
(665, 13, 14, 3, 1, NULL),
(669, 6, 6, 1, 3, NULL),
(670, 7, 6, 2, 3, NULL),
(671, 8, 6, 3, 3, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sizes`
--

CREATE TABLE `sizes` (
  `size_id` bigint(20) NOT NULL,
  `max_length` double NOT NULL,
  `max_width` double NOT NULL,
  `min_hours` int(11) NOT NULL,
  `fixed_rate` int(11) NOT NULL,
  `additional_rate` int(11) NOT NULL,
  `day_rate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sizes`
--

INSERT INTO `sizes` (`size_id`, `max_length`, `max_width`, `min_hours`, `fixed_rate`, `additional_rate`, `day_rate`) VALUES
(1, 1, 1, 3, 40, 20, 5000),
(2, 2, 2, 3, 40, 60, 5000),
(3, 3, 3, 3, 40, 100, 5000);

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `vehicle_id` bigint(20) NOT NULL,
  `vehicle_name` text NOT NULL,
  `vehicle_length` double NOT NULL,
  `vehicle_width` double NOT NULL,
  `record_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`vehicle_id`, `vehicle_name`, `vehicle_length`, `vehicle_width`, `record_id`) VALUES
(1, 'VROOM', 1, 1, NULL),
(2, 'TEST 2', 1, 2, NULL),
(3, 'STEVE', 1, 0.5, NULL),
(4, 'YES YES', 1, 1, NULL),
(5, 'CAR', 2, 2, NULL),
(6, 'BIG CAR', 3, 3, NULL),
(7, 'Test Car', 0.5, 1.5, NULL),
(8, 'MR CAR', 1, 2.5, NULL),
(9, 'LONG CAR', 0.1, 2.7, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `charges`
--
ALTER TABLE `charges`
  ADD PRIMARY KEY (`charge_id`),
  ADD KEY `record_id` (`record_id`),
  ADD KEY `size_id` (`size_id`);

--
-- Indexes for table `distances`
--
ALTER TABLE `distances`
  ADD PRIMARY KEY (`distance_id`),
  ADD KEY `entry_point_id` (`entry_point_id`),
  ADD KEY `slot_id` (`slot_id`);

--
-- Indexes for table `entry_points`
--
ALTER TABLE `entry_points`
  ADD PRIMARY KEY (`entry_point_id`),
  ADD KEY `parking_lot_id` (`parking_lot_id`);

--
-- Indexes for table `parking_lots`
--
ALTER TABLE `parking_lots`
  ADD PRIMARY KEY (`parking_lot_id`);

--
-- Indexes for table `parking_records`
--
ALTER TABLE `parking_records`
  ADD PRIMARY KEY (`record_id`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `parking_lot_id` (`parking_lot_id`);

--
-- Indexes for table `parking_slots`
--
ALTER TABLE `parking_slots`
  ADD PRIMARY KEY (`slot_id`),
  ADD KEY `parking_lot_id` (`parking_lot_id`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `parking_slots_ibfk_2` (`size_id`);

--
-- Indexes for table `sizes`
--
ALTER TABLE `sizes`
  ADD PRIMARY KEY (`size_id`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`vehicle_id`),
  ADD KEY `record_id` (`record_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `charges`
--
ALTER TABLE `charges`
  MODIFY `charge_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `distances`
--
ALTER TABLE `distances`
  MODIFY `distance_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1534;

--
-- AUTO_INCREMENT for table `entry_points`
--
ALTER TABLE `entry_points`
  MODIFY `entry_point_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `parking_lots`
--
ALTER TABLE `parking_lots`
  MODIFY `parking_lot_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `parking_records`
--
ALTER TABLE `parking_records`
  MODIFY `record_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `parking_slots`
--
ALTER TABLE `parking_slots`
  MODIFY `slot_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=672;

--
-- AUTO_INCREMENT for table `sizes`
--
ALTER TABLE `sizes`
  MODIFY `size_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `vehicle_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `charges`
--
ALTER TABLE `charges`
  ADD CONSTRAINT `charges_ibfk_1` FOREIGN KEY (`record_id`) REFERENCES `parking_records` (`record_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `charges_ibfk_2` FOREIGN KEY (`size_id`) REFERENCES `sizes` (`size_id`);

--
-- Constraints for table `distances`
--
ALTER TABLE `distances`
  ADD CONSTRAINT `distances_ibfk_1` FOREIGN KEY (`entry_point_id`) REFERENCES `entry_points` (`entry_point_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `distances_ibfk_2` FOREIGN KEY (`slot_id`) REFERENCES `parking_slots` (`slot_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `entry_points`
--
ALTER TABLE `entry_points`
  ADD CONSTRAINT `entry_points_ibfk_1` FOREIGN KEY (`parking_lot_id`) REFERENCES `parking_lots` (`parking_lot_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `parking_records`
--
ALTER TABLE `parking_records`
  ADD CONSTRAINT `parking_records_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `parking_records_ibfk_2` FOREIGN KEY (`parking_lot_id`) REFERENCES `parking_lots` (`parking_lot_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `parking_slots`
--
ALTER TABLE `parking_slots`
  ADD CONSTRAINT `parking_slots_ibfk_1` FOREIGN KEY (`parking_lot_id`) REFERENCES `parking_lots` (`parking_lot_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `parking_slots_ibfk_2` FOREIGN KEY (`size_id`) REFERENCES `sizes` (`size_id`),
  ADD CONSTRAINT `parking_slots_ibfk_3` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON DELETE SET NULL ON UPDATE NO ACTION;

--
-- Constraints for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`record_id`) REFERENCES `parking_records` (`record_id`) ON DELETE SET NULL ON UPDATE NO ACTION;
--
-- Database: `phpmyadmin`
--
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

--
-- Table structure for table `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int(10) UNSIGNED NOT NULL,
  `dbase` varchar(255) NOT NULL DEFAULT '',
  `user` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `query` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks';

-- --------------------------------------------------------

--
-- Table structure for table `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) NOT NULL,
  `col_name` varchar(64) NOT NULL,
  `col_type` varchar(64) NOT NULL,
  `col_length` text DEFAULT NULL,
  `col_collation` varchar(64) NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) DEFAULT '',
  `col_default` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Table structure for table `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) NOT NULL DEFAULT '',
  `transformation_options` varchar(255) NOT NULL DEFAULT '',
  `input_transformation` varchar(255) NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) NOT NULL,
  `settings_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

-- --------------------------------------------------------

--
-- Table structure for table `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `export_type` varchar(10) NOT NULL,
  `template_name` varchar(64) NOT NULL,
  `template_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

-- --------------------------------------------------------

--
-- Table structure for table `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Table structure for table `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db` varchar(64) NOT NULL DEFAULT '',
  `table` varchar(64) NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp(),
  `sqlquery` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Table structure for table `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

--
-- Dumping data for table `pma__recent`
--

INSERT INTO `pma__recent` (`username`, `tables`) VALUES
('root', '[{\"db\":\"oopl\",\"table\":\"charges\"},{\"db\":\"oopl\",\"table\":\"parking_slots\"},{\"db\":\"oopl\",\"table\":\"entry_points\"},{\"db\":\"oopl\",\"table\":\"vehicles\"},{\"db\":\"oopl\",\"table\":\"sizes\"},{\"db\":\"oopl\",\"table\":\"parking_lots\"},{\"db\":\"oopl\",\"table\":\"parking_records\"},{\"db\":\"oopl\",\"table\":\"distances\"},{\"db\":\"oopl\",\"table\":\"parking_lot\"}]');

-- --------------------------------------------------------

--
-- Table structure for table `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) NOT NULL DEFAULT '',
  `master_table` varchar(64) NOT NULL DEFAULT '',
  `master_field` varchar(64) NOT NULL DEFAULT '',
  `foreign_db` varchar(64) NOT NULL DEFAULT '',
  `foreign_table` varchar(64) NOT NULL DEFAULT '',
  `foreign_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Table structure for table `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `search_name` varchar(64) NOT NULL DEFAULT '',
  `search_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT 0,
  `x` float UNSIGNED NOT NULL DEFAULT 0,
  `y` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `display_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `prefs` text NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

--
-- Dumping data for table `pma__table_uiprefs`
--

INSERT INTO `pma__table_uiprefs` (`username`, `db_name`, `table_name`, `prefs`, `last_update`) VALUES
('root', 'oopl', 'parking_slots', '{\"sorted_col\":\"`parking_slots`.`vehicle_id` ASC\"}', '2023-08-07 06:18:45');

-- --------------------------------------------------------

--
-- Table structure for table `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text NOT NULL,
  `schema_sql` text DEFAULT NULL,
  `data_sql` longtext DEFAULT NULL,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `config_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- Dumping data for table `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2023-08-07 14:52:20', '{\"Console\\/Mode\":\"collapse\",\"ThemeDefault\":\"bootstrap\",\"NavigationWidth\":297}');

-- --------------------------------------------------------

--
-- Table structure for table `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) NOT NULL,
  `tab` varchar(64) NOT NULL,
  `allowed` enum('Y','N') NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Table structure for table `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) NOT NULL,
  `usergroup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- Indexes for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- Indexes for table `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- Indexes for table `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- Indexes for table `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- Indexes for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- Indexes for table `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- Indexes for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- Indexes for table `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- Indexes for table `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- Indexes for table `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- Indexes for table `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- Indexes for table `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- Indexes for table `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Database: `test`
--
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
