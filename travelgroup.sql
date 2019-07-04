-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le :  jeu. 04 juil. 2019 à 07:25
-- Version du serveur :  5.7.24
-- Version de PHP :  7.2.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `travelgroup`
--

-- --------------------------------------------------------

--
-- Structure de la table `activite`
--

DROP TABLE IF EXISTS `activite`;
CREATE TABLE `activite` (
  `id` int(11) NOT NULL,
  `voyage_id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `fos_user`
--

DROP TABLE IF EXISTS `fos_user`;
CREATE TABLE `fos_user` (
  `id` int(11) NOT NULL,
  `username` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username_canonical` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_canonical` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `salt` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `confirmation_token` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_requested_at` datetime DEFAULT NULL,
  `roles` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(DC2Type:array)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `fos_user`
--

INSERT INTO `fos_user` (`id`, `username`, `username_canonical`, `email`, `email_canonical`, `enabled`, `salt`, `password`, `last_login`, `confirmation_token`, `password_requested_at`, `roles`) VALUES
(1, 'Admin', 'admin', 'admin@travelgroup.fr', 'admin@travelgroup.fr', 1, NULL, '$2y$13$1rsg4vJIpeO5KZpD38DfmOYmebTs4VAb11hxhALcRrSBUXC3l/xXK', '2019-07-04 07:21:19', NULL, NULL, 'a:1:{i:0;s:16:\"ROLE_SUPER_ADMIN\";}');

-- --------------------------------------------------------

--
-- Structure de la table `migration_versions`
--

DROP TABLE IF EXISTS `migration_versions`;
CREATE TABLE `migration_versions` (
  `version` varchar(14) COLLATE utf8mb4_unicode_ci NOT NULL,
  `executed_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `migration_versions`
--

INSERT INTO `migration_versions` (`version`, `executed_at`) VALUES
('20190703143440', '2019-07-03 14:44:00'),
('20190703144334', '2019-07-03 14:44:00'),
('20190703144815', '2019-07-03 14:48:20'),
('20190703145327', '2019-07-03 14:53:50');

-- --------------------------------------------------------

--
-- Structure de la table `voyage`
--

DROP TABLE IF EXISTS `voyage`;
CREATE TABLE `voyage` (
  `id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `starting_date` date NOT NULL,
  `ending_date` date NOT NULL,
  `planner_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `voyage_user`
--

DROP TABLE IF EXISTS `voyage_user`;
CREATE TABLE `voyage_user` (
  `voyage_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `activite`
--
ALTER TABLE `activite`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_B875551568C9E5AF` (`voyage_id`);

--
-- Index pour la table `fos_user`
--
ALTER TABLE `fos_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_957A647992FC23A8` (`username_canonical`),
  ADD UNIQUE KEY `UNIQ_957A6479A0D96FBF` (`email_canonical`),
  ADD UNIQUE KEY `UNIQ_957A6479C05FB297` (`confirmation_token`);

--
-- Index pour la table `migration_versions`
--
ALTER TABLE `migration_versions`
  ADD PRIMARY KEY (`version`);

--
-- Index pour la table `voyage`
--
ALTER TABLE `voyage`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_3F9D89555346EAE1` (`planner_id`);

--
-- Index pour la table `voyage_user`
--
ALTER TABLE `voyage_user`
  ADD PRIMARY KEY (`voyage_id`,`user_id`),
  ADD KEY `IDX_1D011EC768C9E5AF` (`voyage_id`),
  ADD KEY `IDX_1D011EC7A76ED395` (`user_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `activite`
--
ALTER TABLE `activite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `fos_user`
--
ALTER TABLE `fos_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `voyage`
--
ALTER TABLE `voyage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `activite`
--
ALTER TABLE `activite`
  ADD CONSTRAINT `FK_B875551568C9E5AF` FOREIGN KEY (`voyage_id`) REFERENCES `voyage` (`id`);

--
-- Contraintes pour la table `voyage`
--
ALTER TABLE `voyage`
  ADD CONSTRAINT `FK_3F9D89555346EAE1` FOREIGN KEY (`planner_id`) REFERENCES `fos_user` (`id`);

--
-- Contraintes pour la table `voyage_user`
--
ALTER TABLE `voyage_user`
  ADD CONSTRAINT `FK_1D011EC768C9E5AF` FOREIGN KEY (`voyage_id`) REFERENCES `voyage` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_1D011EC7A76ED395` FOREIGN KEY (`user_id`) REFERENCES `fos_user` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
