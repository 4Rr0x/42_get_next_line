/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line_bonus.c                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jopedro- <jopedro-@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/12/02 11:47:05 by jopedro-          #+#    #+#             */
/*   Updated: 2024/12/02 11:52:24 by jopedro-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line_bonus.h"

char	*ft_read_file(int fd, char *text)
{
	char	*buff;
	int		bytes_read;

	buff = malloc(sizeof(char) * (BUFFER_SIZE + 1));
	if (!buff)
		return (NULL);
	bytes_read = 1;
	while (bytes_read != 0 && ft_strchr(text, '\n'))
	{
		bytes_read = read(fd, buff, BUFFER_SIZE);
		if (bytes_read == -1)
		{
			free(buff);
			return (NULL);
		}
		buff[bytes_read] = '\0';
		text = ft_strjoin(text, buff);
	}
	free(buff);
	return (text);
}

char	*ft_find_line(char	*text)
{
	int		i;
	int		j;
	char	*line;

	if (!text)
		return (NULL);
	i = 0;
	while (text[i] && text[i] != '\n')
	{
		i++;
	}
	line = (char *)malloc(sizeof(char) * (i + 2));
	if (!line)
		return (NULL);
	j = 0;
	while (text[i] && j < i)
	{
		line[j] = text[j];
		j++;
	}
	line[j++] = '\n';
	line[j] = '\0';
	return (line);
}

char	*get_next_line(int fd)
{
	char		*line;
	static char	*text[4096];

	if (fd < 0 || BUFFER_SIZE <= 0)
		return (0);
	text[fd] = ft_read_file(fd, text[fd]);
	if (!text[fd])
		return (NULL);
	line = ft_find_line(text[fd]);
	text[fd] = ft_leftovers(text[fd]);
	return (line);
}
