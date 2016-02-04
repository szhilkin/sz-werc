<?xml version="1.0" encoding="utf-8"?>

%{
# See for more info:http://www.tbray.org/ongoing/When/200x/2005/07/27/Atomic-RSS
fn statpost {
    f = $1

    updated = `{date -t `{mtime $f | awk '{print $1}'}} # date -t is 9front/9base only
    post_uri=$base_url^`{cleanname `{echo $f | sed -e 's!^'$sitedir'!!'}}^'/'
    title=`{read $f/index.md}
    # Not used: date=`{/bin/date -Rd `{basename $f |sed 's/(^[0-9\-]*).*/\1/; s/-[0-9]$//'}}
    # TODO: use mtime(1) and ls(1) instead of lunix's stat(1)
    #stat=`{stat -c '%Y %U' $f}
    #mdate=`{/bin/date -Rd `{mtime $f|awk '{print $1}' }} # Not used because it is unreliable
    by=`{ls -m $f | sed 's/^\[//g; s/].*$//g' >[2]/dev/null}
    #ifs=() { summary=`{cat $f/index.md | crop_text 1024 ... | $formatter } }
    ifs=() { summary=`{cat $f/index.md | strip_title_from_md_file | ifs=$difs {$formatter} } }
}
updated = `{date -t} # date -t is 9front/9base only
%}

<feed xmlns="http://www.w3.org/2005/Atom"
    xmlns:thr="http://purl.org/syndication/thread/1.0">

% if(! ~ $"conf_blog_pubsubdub_hub '') {
%    echo '<link rel="hub" href="'$conf_blog_pubsubdub_hub'" />'
% }

    <link rel="self" href="%($base_url^$req_path%)"/>
    <id>%($base_url^$req_path%)</id>
    <icon><![CDATA[/favicon.ico]]></icon>

    <title><![CDATA[%($siteTitle%)]]></title>
    <subtitle><![CDATA[%($siteSubTitle%)]]></subtitle>

% # <updated>2008-09-24T12:47:00-04:00</updated>
    <updated>%($updated%)</updated>
    <link href="."/>

% for(f in `{get_post_list $blagh_root$blagh_dirs}) {
%    statpost $f

    <entry>
% # Maybe we should be smarter, see: http://diveintomark.org/archives/2004/05/28/howto-atom-id, example: <id>tag:intertwingly.net,2004:2899</id>
        <id>%($post_uri%)</id>
        <link href="%($post_uri%)"/>
        <title><![CDATA[%($title%)]]></title>
% # <link rel="replies" href="2899.atom" thr:count="0"/>
        <author><name><![CDATA[%($by%)]]></name></author>


        <content type="xhtml"><div xmlns="http://www.w3.org/1999/xhtml">
            <![CDATA[%($summary%)]]>
        </div></content>

        <updated>%($updated%)</updated>
    </entry>

% }

</feed>

% exit 
