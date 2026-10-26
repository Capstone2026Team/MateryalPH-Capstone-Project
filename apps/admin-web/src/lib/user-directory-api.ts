import {
  AdminUserDirectoryApi,
  type DirectoryBuyerProfile,
  type DirectoryBuyerRow,
  type DirectoryListing,
  type DirectoryPageMeta,
  type DirectoryReview,
  type DirectorySanction,
  type DirectoryVendorProfile,
  type DirectoryVendorRow,
  type ListDirectoryBuyerReviewsRequest,
  type ListDirectoryBuyersRequest,
  type ListDirectoryVendorListingsRequest,
  type ListDirectoryVendorReviewsRequest,
  type ListDirectoryVendorsRequest,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration, readDirectoryBuyerPhoto } from '@materyalph/web-ui'

export type { DirectoryBuyerProfile, DirectoryBuyerRow, DirectoryListing, DirectoryPageMeta, DirectoryReview, DirectorySanction, DirectoryVendorProfile, DirectoryVendorRow }
/** Value types of each filter, so a selected option can be narrowed to the generated enum without an `undefined` member. */
type Values<T> = { [K in keyof T]-?: NonNullable<T[K]> }
export type BuyerFilters = Values<ListDirectoryBuyersRequest>
export type BuyerReviewFilters = Values<ListDirectoryBuyerReviewsRequest>
export type VendorFilters = Values<ListDirectoryVendorsRequest>
export type VendorReviewFilters = Values<ListDirectoryVendorReviewsRequest>
export type DirectoryList<T> = { items: T[]; meta: DirectoryPageMeta }

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const api = () => new AdminUserDirectoryApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const listOf = <T>(response: { data: T[]; meta: DirectoryPageMeta }): DirectoryList<T> => ({ items: response.data, meta: response.meta })

export const BUYER_STATUSES = ['ACTIVE', 'PENDING_VERIFICATION', 'SUSPENDED', 'DEACTIVATED', 'DELETED'] as const
export const VENDOR_ACTIVATION_STATUSES = ['ACTIVE', 'READY', 'NOT_READY', 'RESTRICTED', 'SUSPENDED'] as const
export const VENDOR_VERIFICATION_STATUSES = ['NOT_STARTED', 'IN_PROGRESS', 'SUBMITTED', 'PENDING_VERIFICATION', 'APPROVED', 'CHANGES_REQUIRED', 'REJECTED', 'EXPIRED'] as const

export async function listDirectoryBuyers(filters: ListDirectoryBuyersRequest): Promise<DirectoryList<DirectoryBuyerRow>> {
  return listOf(await api().listDirectoryBuyers(filters))
}
export async function getDirectoryBuyer(buyerId: string): Promise<DirectoryBuyerProfile> {
  return (await api().getDirectoryBuyer({ buyerId })).data
}
export const getDirectoryBuyerPhoto = (buyerId: string, signedUrl: string): Promise<Blob> => readDirectoryBuyerPhoto(basePath, buyerId, signedUrl)
export async function listDirectoryBuyerReviews(filters: ListDirectoryBuyerReviewsRequest): Promise<DirectoryList<DirectoryReview>> {
  return listOf(await api().listDirectoryBuyerReviews(filters))
}
export async function listDirectoryVendors(filters: ListDirectoryVendorsRequest): Promise<DirectoryList<DirectoryVendorRow>> {
  return listOf(await api().listDirectoryVendors(filters))
}
export async function getDirectoryVendor(vendorId: string): Promise<DirectoryVendorProfile> {
  return (await api().getDirectoryVendor({ vendorId })).data
}
export async function listDirectoryVendorReviews(filters: ListDirectoryVendorReviewsRequest): Promise<DirectoryList<DirectoryReview>> {
  return listOf(await api().listDirectoryVendorReviews(filters))
}
export async function listDirectoryVendorListings(filters: ListDirectoryVendorListingsRequest): Promise<DirectoryList<DirectoryListing>> {
  return listOf(await api().listDirectoryVendorListings(filters))
}
