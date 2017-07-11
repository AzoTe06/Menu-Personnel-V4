CREATE TABLE IF NOT EXISTS `user_phonelist` (
  `owner_id` varchar(50) NOT NULL,
  `contact_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `user_message` (
  `owner_id` varchar(50) NOT NULL,
  `receiver_id` varchar(50) NOT NULL,
  `msg` varchar(200) NOT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `has_read` int(11) NOT NULL DEFAULT '0',
  `receiver_deleted` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `users`
  ADD COLUMN `lastpos` varchar(255) DEFAULT '{-1044.99914550781,-2749.8173828125,21.3634204864502}',
  ADD COLUMN `isFirstConnection` int(11) DEFAULT '1',
  ADD COLUMN `nom` varchar(128) NOT NULL DEFAULT '',
  ADD COLUMN `prenom` varchar(128) NOT NULL DEFAULT '',
  ADD COLUMN `dateNaissance` date DEFAULT '1980-01-01',
  ADD COLUMN `sexe` varchar(1) NOT NULL DEFAULT 'f',
  ADD COLUMN `taille` int(10) unsigned NOT NULL DEFAULT '0',
  ADD COLUMN `phone_number` varchar(50) DEFAULT '0';
