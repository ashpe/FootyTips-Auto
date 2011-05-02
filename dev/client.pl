use Data::Dumper;

require RPC::XML;
require RPC::XML::Client;

my $proxy = 'https://192.168.0.101:443/';

$ENV{HTTPS_PROXY} = $proxy;
$ENV{HTTPS_DEBUG} = 1;
$ENV{HTTPS_VERSION} = 3;
$ENV{HTTPS_CA_DIR}    = '/etc/nginx/';
$ENV{HTTPS_CA_FILE}    = '/etc/nginx/server.crt';

$cli = RPC::XML::Client->new($proxy);

my $req = RPC::XML::request->new('get_login', RPC::XML::string->new('ashpe'), RPC::XML::string->new('brodie123'));
$resp = $cli->send_request($req);

print Dumper($resp->value);

