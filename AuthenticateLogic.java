package net.viralpatel.struts2.logic;

import java.util.ArrayList;
import java.util.List;

import net.viralpatel.struts2.model.M_User;
import net.viralpatel.struts2.model.manz_h10f;
import net.viralpatel.struts2.model.manz_h10fEdit;
import net.viralpatel.struts2.model.manz_z10f;
import net.viralpatel.struts2.model.manz_z10fEdit;
import net.viralpatel.struts2.util.HibernateUtil;

import org.hibernate.Query;
import org.hibernate.classic.Session;

public class AuthenticateLogic extends HibernateUtil {

	/**
	 * Get 品目名 from table manz_z10f from the value 品目k of table manz_h10f and the value 品目k of table manz_z10f
	 * @param 品目k: It is value of Object manz_h10f
	 * @return 品目名: have value
	 * @return null: is null
	 */
	public String get品目名(String 品目k) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();
			manz_z10f man_z = (manz_z10f) hbSession
					.createQuery("Select u from manz_z10f u where u.品目k = :品目k")
					.setParameter("品目k", 品目k).uniqueResult();

			if (man_z != null)
				return man_z.get品目名();

			hbSession.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e);
			hbSession.getTransaction().rollback();
		}
		return null;
	}

	/**
	 * Get 品番 from table manz_h10f from the value 発注noof table manz_h10f and the value 発注no of table manz_z10f
	 * @param 発注no: It is value of Object manz_h10f
	 * @return 品番: have value
	 * @return null: is null
	 */
	public String get品番(String 発注no) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();
			manz_h10f man_h = (manz_h10f) hbSession
					.createQuery(
							"Select u from manz_h10f u where u.発注no = :発注no")
					.setParameter("発注no", 発注no).uniqueResult();

			if (man_h != null)
				return man_h.get品番();

			hbSession.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e);
			hbSession.getTransaction().rollback();
		}
		return null;
	}

	/**
	 * Set value of object List<manz_h10fEdit> from the object List<manz_h10f>
	 * @param listResult: The value of object List<manz_h10f>
	 * @return result
	 */
	public List<manz_h10fEdit> setManz_h10fEditToTable(
			List<manz_h10f> listResult) {
		List<manz_h10fEdit> result = new ArrayList<manz_h10fEdit>();

		for (manz_h10f index : listResult) {
			result.add(new manz_h10fEdit(index.get発注no(), index.get品番(), index
					.get完納(), get品目名(index.get品目k()), index.get単価(), index
					.get金額(), index.get納入先(), index.get備考(), index.get数量()));
		}

		return result;
	}

	/**
	 * Set value of object List<manz_z10fEdit> from the object List<manz_z10f>
	 * @param listResult: The value of object List<manz_h10f>
	 * @return result
	 */
	public List<manz_z10fEdit> setManz_z10fEditToTable(
			List<manz_z10f> listResult) {
		List<manz_z10fEdit> result = new ArrayList<manz_z10fEdit>();

		for (manz_z10f index : listResult) {
			result.add(new manz_z10fEdit(index.get品目c(), index.get品目名(),
					get品番(index.get発注no()), index.get新在庫数量(), index.get在庫日(),
					index.get得意先名(), index.getメーカーロット(), index.get品名()));
		}

		return result;
	}

	/**
	 * Check object have already existed in database
	 * @param 発注no: id of table manz_h10f
	 * @return true: exist
     * @return false: not exist
	 */
	public boolean checkExistManz_h10f(String 発注no) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();
			manz_h10f man_h = (manz_h10f) hbSession
					.createQuery(
							"Select u from manz_h10f u where u.発注no = :発注no")
					.setParameter("発注no", 発注no).uniqueResult();

			if (man_h != null)
				return true;

			hbSession.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e);
			hbSession.getTransaction().rollback();
		}
		return false;
	}

	/**
	 * Delete row to table manz_h10f
	 * @param 発注no: Condition to remove
	 */
	public void deleteManz_h10f(String 発注no) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();
			hbSession
					.createQuery(
							"delete from manz_h10f u where u.発注no = :発注no ")
					.setParameter("発注no", 発注no).executeUpdate();
			// hbSession.delete(dataManz_h);

			hbSession.getTransaction().commit();
			System.err.println("delete" + 発注no);
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("**************" + e + "*****************");
			hbSession.getTransaction().rollback();
		}
	}

	/**
	 * Delete row to table manz_z10f
	 * @param 品目c: Condition to remove
	 */
	public void deleteManz_z10f(String 品目c) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();
			hbSession
					.createQuery("delete from manz_z10f u where u.品目c = :品目c ")
					.setParameter("品目c", 品目c).executeUpdate();

			hbSession.getTransaction().commit();
			System.err.println("delete " + 品目c);
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("**************" + e + "*****************");
			hbSession.getTransaction().rollback();
		}
	}

	/**
	 * Delete row to table manz_h10f
	 * @param dataManz_h: Condition to remove
	 */
	public void deleteManz_h10f(manz_h10f dataManz_h) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();
			hbSession
					.createQuery(
							"delete from manz_h10f u where u.発注no = :発注no ")
					.setParameter("発注no", dataManz_h.get発注no()).executeUpdate();
			// hbSession.delete(dataManz_h);

			hbSession.getTransaction().commit();
			System.err.println("delete" + dataManz_h.get発注no());
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("**************" + e + "*****************");
			hbSession.getTransaction().rollback();
		}
	}

	/**
	 * Add row to table manz_h10f
	 * @param dataManz_h
	 * @param dataManz_hEdit
	 */
	public void addManz_h10fEditNotCondition(manz_h10f dataManz_h,
			manz_h10fEdit dataManz_hEdit) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();
			dataManz_h.set発注no(dataManz_hEdit.get発注no());
			dataManz_h.set品番(dataManz_hEdit.get品番());
			dataManz_h.set完納(dataManz_hEdit.get完納());
			dataManz_h.set単価(dataManz_hEdit.get単価());
			dataManz_h.set金額(dataManz_hEdit.get金額());
			dataManz_h.set納入先(dataManz_hEdit.get納入先());
			dataManz_h.set備考(dataManz_hEdit.get備考());
			dataManz_h.set数量(dataManz_hEdit.get数量());

			hbSession.save(dataManz_h);
			System.err.println("add " + dataManz_h.get発注no());

			hbSession.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("**************" + e + "*****************");
			hbSession.getTransaction().rollback();
		}
	}

	/**
	 * Update row to table manz_z10f
	 * @param dataManz_h
	 * @param dataManz_hEdit
	 */
	public void updateManz_h10fEditNotCondition(manz_h10f dataManz_h,
			manz_h10fEdit dataManz_hEdit) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();

			// Update the value of 品目名
			manz_z10f man_z = (manz_z10f) hbSession
					.createQuery("Select u from manz_z10f u where u.品目k = :品目k")
					.setParameter("品目k", dataManz_h.get品目k()).uniqueResult();
			if (man_z != null) {
				if (man_z.get品目c() != null && dataManz_hEdit.get品目名() != null
						&& !dataManz_hEdit.get品目名().equals("")) {
					man_z.set品目名(dataManz_hEdit.get品目名());
					hbSession.update(man_z);
				}
			}

			hbSession.getTransaction().commit();
			System.err.println("update " + dataManz_h.get発注no());
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("**************" + e + "*****************");
			hbSession.getTransaction().rollback();
		}
	}

	/**
	 * Add row to table manz_z10f
	 * @param dataManz_z
	 * @param dataManz_zEdit
	 */
	public void addManz_z10fEditNotCondition(manz_z10f dataManz_z,
			manz_z10fEdit dataManz_zEdit) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();
			dataManz_z.set品目c(dataManz_zEdit.get品目c());
			dataManz_z.set品目名(dataManz_zEdit.get品目名());
			dataManz_z.set新在庫数量(dataManz_zEdit.get新在庫数量());
			dataManz_z.set在庫日(dataManz_zEdit.get在庫日());
			dataManz_z.set得意先名(dataManz_zEdit.get得意先名());
			dataManz_z.setメーカーロット(dataManz_zEdit.getメーカーロット());
			dataManz_z.set品名(dataManz_zEdit.get品名());

			hbSession.save(dataManz_z);

			hbSession.getTransaction().commit();
			System.err.println("add " + dataManz_z.get品目c());
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("**************" + e + "*****************");
			hbSession.getTransaction().rollback();
		}
	}

	/**
	 * Update row to table manz_h10f
	 * @param dataManz_z
	 * @param dataManz_zEdit
	 */
	public void updateManz_z10fEditNotCondition(manz_z10f dataManz_z,
			manz_z10fEdit dataManz_zEdit) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();
			// Update the value of 品番
			manz_h10f man_h = (manz_h10f) hbSession
					.createQuery(
							"Select u from manz_h10f u where u.発注no = :発注no")
					.setParameter("発注no", dataManz_z.get発注no()).uniqueResult();

			if (man_h != null) {
				if (man_h.get発注no() != null && dataManz_zEdit.get品番() != null
						&& !dataManz_zEdit.get品番().equals(""))
					man_h.set品番(dataManz_zEdit.get品番());
				hbSession.update(man_h);
			}

			hbSession.getTransaction().commit();
			System.err.println("update " + dataManz_z.get品目c());
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("**************" + e + "*****************");
			hbSession.getTransaction().rollback();
		}
	}

	/**
	 * Add row to table manz_h10f
	 * @param dataManz_h
	 * @return
	 */
	public int addManz_h10f(manz_h10f dataManz_h) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();

			// Value of 発注no is null
			if (dataManz_h.get発注no().equals(null)
					|| dataManz_h.get発注no().trim().equals("")) {
				return 1;
			} else {
				manz_h10f man_h = (manz_h10f) hbSession
						.createQuery(
								"Select u from manz_h10f u where u.発注no = :発注no")
						.setParameter("発注no", dataManz_h.get発注no())
						.uniqueResult();
				// 発注no is already exists
				if (man_h != null) {
					return 2;
				}
				manz_z10f data = (manz_z10f) hbSession
						.createQuery(
								"Select v from manz_z10f v where v.品目k = :品目k")
						.setParameter("品目k", dataManz_h.get品目k())
						.uniqueResult();
				// 品目k isn't exists
				if (data == null) {
					return 3;
				}
				hbSession.save(dataManz_h);
				System.err.println("add" + dataManz_h.get発注no());
			}

			hbSession.getTransaction().commit();
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("**************" + e + "*****************");
			hbSession.getTransaction().rollback();
		}
		return -1;
	}

	/**
	 * Add row to table manz_z10f
	 * @param dataManz_z
	 * @return
	 */
	public int addManz_z10f(manz_z10f dataManz_z) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();

			// Value of 発注no is null
			if (dataManz_z.get品目c().equals(null)
					|| dataManz_z.get品目c().trim().equals("")) {
				return 1;
			} else {
				manz_z10f man_z = (manz_z10f) hbSession
						.createQuery(
								"Select u from manz_z10f u where u.品目c = :品目c")
						.setParameter("品目c", dataManz_z.get品目c())
						.uniqueResult();
				// 発注no is already exists
				if (man_z != null) {
					return 2;
				}
				manz_h10f data = (manz_h10f) hbSession
						.createQuery(
								"Select v from manz_h10f v where v.発注no = :発注no")
						.setParameter("発注no", dataManz_z.get発注no())
						.uniqueResult();
				// 品目k isn't exists
				if (data == null) {
					return 3;
				}
				hbSession.save(dataManz_z);
				System.err.println("add" + dataManz_z.get品目c());
			}

			hbSession.getTransaction().commit();
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("**************" + e + "*****************");
			hbSession.getTransaction().rollback();
		}
		return -1;
	}

	/**
	 * Get data from table manz_h10f
	 * @param username: Condition to select
	 * @return listResult: If Username have valued
	 * @return null: else 
	 */
	public List<manz_h10f> getTableManzh10f(String username) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();

			// Query sql = hbSession.createQuery("Select u from manz_h10f u ");
			Query sql = hbSession.createQuery(
					"Select u from manz_h10f u where u.username = :username")
					.setParameter("username", username);
			@SuppressWarnings("unchecked")
			List<manz_h10f> listResult = (List<manz_h10f>) sql.list();
			hbSession.getTransaction().commit();

			return listResult;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e);
			hbSession.getTransaction().rollback();
		}
		return null;
	}

	/**
	 * Get data from table manz_z10f
	 * @param username: Condition to select
	 * @return listResult: If Username have valued
	 * @return null: else 
	 */
	public List<manz_z10f> getTableManzz10f(String username) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();

			// Query sql = hbSession.createQuery("Select u from manz_z10f u");

			Query sql = hbSession.createQuery(
					"Select u from manz_z10f u where u.username = :username")
					.setParameter("username", username);

			@SuppressWarnings("unchecked")
			List<manz_z10f> listResult = (List<manz_z10f>) sql.list();
			hbSession.getTransaction().commit();

			return listResult;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e);
			hbSession.getTransaction().rollback();
		}
		return null;
	}

	/**
	 * get account of user
	 * @param strUsername: username
	 * @param strPassword: password
	 * @return user: acount of user login
	 */
	public M_User check(String strUsername, String strPassword) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		hbSession.beginTransaction();

		M_User user = (M_User) hbSession
				.createQuery(
						"Select u from M_User u where u.username = :username and u.password = :password")
				.setParameter("username", strUsername)
				.setParameter("password", strPassword).uniqueResult();
		hbSession.getTransaction().commit();

		return user;
	}

	/**
	 * Check account of user when they login to system.
	 * @param strUsername: username
	 * @param strPassword: password
	 * @return true: username or password is validate in DB,
	 * @return false: username or password isn't validate in DB,
	 */
	public boolean checkLogin(String strUsername, String strPassword) {
		Session hbSession = HibernateUtil.getSessionFactory()
				.getCurrentSession();
		try {
			hbSession.beginTransaction();

			Query sql = null;
			if (strUsername == null && strPassword == null) {
				return false;
			} else {
				if (strUsername != null && strPassword != null) {
					sql = hbSession
							.createQuery(
									"Select u from M_User u where u.username = :username and u.password = :password")
							.setParameter("username", strUsername)
							.setParameter("password", strPassword);
				} else {
					if (strPassword == null) {
						sql = hbSession
								.createQuery(
										"Select u from M_User u where u.username = :username")
								.setParameter("username", strUsername);
					} else {
						if (strUsername == null) {
							sql = hbSession
									.createQuery(
											"Select u from M_User u where  u.password = :password")
									.setParameter("password", strPassword);
						}
					}
				}
			}

			M_User results = (M_User) sql.uniqueResult();
			hbSession.getTransaction().commit();
			if (results != null)
				return true;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e);
			hbSession.getTransaction().rollback();
		}
		return false;
	}
}
