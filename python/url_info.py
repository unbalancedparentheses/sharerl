from newspaper import Article

def info(burl):
    url = burl.decode('ascii')
    article = Article(url)
    article.download()
    article.parse()

    title = article.title
    #TODO: each author in authors needs to be bytes type
    authors = article.authors
    text = article.text

    return (bytes(title, 'utf-8'), authors, bytes(text, 'utf-8'))
