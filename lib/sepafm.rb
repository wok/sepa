# 3rd party dependencies
require 'active_model'
require 'base64'
require 'nokogiri'
require 'openssl'
require 'savon'
require 'securerandom'
require 'time'

# Used throughout project so it's important that these be required first
require 'sepa/utilities'

# Common, again important to require in this order
require 'sepa/error_messages'
require 'sepa/response'

require 'sepa/application_request'
require 'sepa/application_response'
require 'sepa/attribute_checks'
require 'sepa/banks/danske/danske_response'
require 'sepa/banks/danske/soap_danske'
require 'sepa/banks/nordea/nordea_response'
require 'sepa/banks/nordea/soap_nordea'
require 'sepa/banks/op/op_response'
require 'sepa/banks/op/soap_op'
require 'sepa/banks/samlink/samlink_response'
require 'sepa/banks/samlink/soap_samlink'
require 'sepa/client'
require 'sepa/soap_builder'
require 'sepa/version'

# The root path of where the gem is installed
# @todo Put all constants under Sepa namespace
ROOT_PATH = File.expand_path('../../', __FILE__)

# @!group Schemas

# The path where the WSDL-files for different banks are located
WSDL_PATH = "#{ROOT_PATH}/lib/sepa/wsdl".freeze

# The path where the xml schemas are located
SCHEMA_PATH = "#{ROOT_PATH}/lib/sepa/xml_schemas".freeze

# Path to the WSDL schema
SCHEMA_FILE = "#{ROOT_PATH}/lib/sepa/xml_schemas/wsdl.xml".freeze

# @!endgroup

# @!group Templates

# Path to the application request templates
AR_TEMPLATE_PATH = "#{ROOT_PATH}/lib/sepa/xml_templates/application_request".freeze

# Path to the soap templates
SOAP_TEMPLATE_PATH = "#{ROOT_PATH}/lib/sepa/xml_templates/soap".freeze

# @!endgroup

# @!group Certificates

# Path to where the certificates are located
CERTIFICATE_PATH = "#{ROOT_PATH}/lib/sepa/certificates/".freeze

nordea_root_certificate_string = File.read("#{CERTIFICATE_PATH}nordea_root_certificate.pem")

# Nordea's root certificate as an OpenSSL::X509::Certificate
NORDEA_ROOT_CERTIFICATE = OpenSSL::X509::Certificate.new nordea_root_certificate_string

danske_root_certificate_string = File.read("#{CERTIFICATE_PATH}danske_root_certificate.pem")

# Danske Bank's root certificate as an OpenSSL::X509::Certificate
DANSKE_ROOT_CERTIFICATE = OpenSSL::X509::Certificate.new danske_root_certificate_string

op_root_certificate_string = File.read("#{CERTIFICATE_PATH}op_root_certificate.pem")

# OP's root certificate as an OpenSSL::X509::Certificate
OP_ROOT_CERTIFICATE = OpenSSL::X509::Certificate.new op_root_certificate_string

samlink_root_certificate_string = File.read("#{CERTIFICATE_PATH}samlink_root_certificate.pem")
samlink_certificate_string      = File.read("#{CERTIFICATE_PATH}samlink_certificate.pem")

# Samlink's certificates as OpenSSL::X509::Certificate
SAMLINK_ROOT_CERTIFICATE = OpenSSL::X509::Certificate.new samlink_root_certificate_string
SAMLINK_CERTIFICATE      = OpenSSL::X509::Certificate.new samlink_certificate_string

# @!endgroup

# @!group Commands

# Commands described in the standard
STANDARD_COMMANDS = %i(
  download_file
  download_file_list
  get_user_info
  upload_file
).freeze

SUPPORTED_COMMANDS =
  STANDARD_COMMANDS +
  %i(
    create_certificate
    get_bank_certificate
    get_certificate
    renew_certificate
    get_service_certificates
  )

# @!endgroup

# @!group XML Namespaces

# Namespace used by XML digital signature
DSIG = 'http://www.w3.org/2000/09/xmldsig#'.freeze

# Oasis utility namespace used in soap header for security purposes
OASIS_UTILITY = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'.freeze

# Oasis secext namespace used in soap header for security purposes
OASIS_SECEXT = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'.freeze

# Namespace used in application requests and application responses
XML_DATA = 'http://bxd.fi/xmldata/'.freeze

# Namespace of the node that contains application request or application response
BXD = 'http://model.bxd.fi'.freeze

# Namespace for XML encryption syntax and processing
XMLENC = 'http://www.w3.org/2001/04/xmlenc#'.freeze

# Soap envelope namespace
ENVELOPE = 'http://schemas.xmlsoap.org/soap/envelope/'.freeze

# Namespace used in Nordea's certificate requests and responses soap
NORDEA_PKI = 'http://bxd.fi/CertificateService'.freeze

# Namespace used in Nordea's certificate application requests and responses
NORDEA_XML_DATA = 'http://filetransfer.nordea.com/xmldata/'.freeze

# Namespace used in Danske Bank's certificate services application requests and responses
DANSKE_PKI  = 'http://danskebank.dk/PKI/PKIFactoryService/elements'.freeze

# Namespace used in Danske Bank's certificate services soap
DANSKE_PKIF = 'http://danskebank.dk/PKI/PKIFactoryService'.freeze

# Namespace used in OP's certificate requests and responses soap
OP_PKI = 'http://mlp.op.fi/OPCertificateService'.freeze

# Namespace used in OP's certificate application requests and responses
OP_XML_DATA = 'http://op.fi/mlp/xmldata/'.freeze

SAMLINK_PKI = 'http://mlp.op.fi/OPCertificateService'.freeze

# @!endgroup
